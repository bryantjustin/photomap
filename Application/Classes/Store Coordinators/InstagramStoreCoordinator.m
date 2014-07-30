//
//  InstagramStoreCoordinator.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "InstagramStoreCoordinator.h"

#import "CoreDataStoreCoordinator.h"
#import "InstagramUser.h"
#import "InstagramComment.h"
#import "InstagramMedia.h"
#import "InstagramObjectMapper.h"

static NSInteger const SelfUserEntityLimit      = 1;
static NSInteger const MediaBatchSize           = 20;

static NSString *const IDEntityAttributeName            = @"id";
static NSString *const ObjectIDEntityAttributeName      = @"objectID";
static NSString *const CreatedDateEntityAttributeName   = @"createdDate";



/******************************************************************************/

#pragma mark - Class Extension

/******************************************************************************/

@interface InstagramStoreCoordinator ()

@end



/******************************************************************************/

#pragma mark - Class Implementation

/******************************************************************************/

@implementation InstagramStoreCoordinator
{
    NSMutableDictionary *_objectIDsByIDByEntity;
}



/******************************************************************************/

#pragma mark - Singleton reference

/******************************************************************************/

+ (instancetype)defaultStoreCoordinator
{
    static dispatch_once_t predicate = 0ul;
    static id instance = nil;
    
    dispatch_once(
        &predicate,
        ^(void)
        {
            instance = [self new];
        }
    );
    
    return instance;
}



/******************************************************************************/

#pragma mark - Initialize By Fetching All Managed Object IDs

/******************************************************************************/

- (void)initializeByFetchingManagedObjectIDsWithCompletionBlock:(InstagramStoreCoordinatorErrorBlock)completion
{
    // !!!
    //
    // For basic objects, find and create is typically implemented using a combination of a sorted fetch request
    // by a unique key, using the IN operator in a predicate followed by a matching algorithm for existing
    // objects. However, because the data structure involved includes relationships, it makes the fetch complex.
    // A faster but more (relatively) memory expensive alternative is to load all the managed object IDs and store
    // them by unique key, so that checking for existence is a lot easier.
    //
    // Saving a plist to disk was also considered. The problem with this is that NSManagedObjectIDs change between
    // migrations will become stale if a migration does occur.
    
    NSManagedObjectContext *workerQueueContext = [CoreDataStoreCoordinator.sharedStoreCoordinator spawnWorkerContext];
    [workerQueueContext
        performBlock:^(void)
        {
            NSError *error = nil;
            NSArray *entityNames =
            @[
                InstagramUserEntityName,
                InstagramMediaEntityName,
                InstagramCommentEntityName
            ];
            
            for (NSString *entityName in entityNames)
            {
                [self
                    fetchManagedObjectIDsForEntityName:entityName
                    withContext:workerQueueContext
                    andError:&error
                ];
                
                // If error is found, break and handle by returning to the main queue.
                // Insert is pretty much toast if an error occurs. Should probably force
                // and exist at that point.
                
                if (error)
                {
                    break;
                }
            }
            
            NSManagedObjectContext *mainQueueContext = CoreDataStoreCoordinator.sharedStoreCoordinator.mainManagedObjectContext;
            [mainQueueContext
                performBlock:^(void)
                {
                    if (error)
                    {
                        NSLog( @"ERROR: Failed to fetch and cache managed object ids – %@", error.localizedDescription );
                    }
                    
                    completion(error);
                }
            ];
        }
    ];
}

- (void)fetchManagedObjectIDsForEntityName:(NSString *)entityName
    withContext:(NSManagedObjectContext *)context
    andError:(NSError **)error;
{
    // Set up to retrieve NSManagedObjectIDs and IDs
            
    NSExpressionDescription *objectIDDescription    = [NSExpressionDescription new];
    objectIDDescription.expression                  = [NSExpression expressionForEvaluatedObject];
    objectIDDescription.expressionResultType        = NSObjectIDAttributeType;
    objectIDDescription.name                        = ObjectIDEntityAttributeName;
    
    // Set up fetch request to retrieve users objectsIDs and IDs.
    
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    [fetchRequest setResultType: NSDictionaryResultType];
    [fetchRequest setReturnsDistinctResults:YES];
    [fetchRequest
        setEntity:[NSEntityDescription
            entityForName:entityName
            inManagedObjectContext:context
        ]
    ];
    [fetchRequest
        setPropertiesToFetch:
        @[
            objectIDDescription,
            IDEntityAttributeName
        ]
    ];
    
    NSArray *dictionaries = [context
        executeFetchRequest:fetchRequest
        error:error
    ];
    
    for (NSDictionary *dictionary in dictionaries)
    {
        NSManagedObjectID *objectID  = dictionary[ObjectIDEntityAttributeName];
        NSString *id                 = dictionary[IDEntityAttributeName];
        
        [self
            setObjectID:objectID
            forEntityName:entityName
            andID:id
        ];
    }
}


/******************************************************************************/

#pragma mark - Self User Details Methods

/******************************************************************************/

- (void)cacheSelfUserDetailsResponse:(NSDictionary *)response
    withCompletion:(InstagramStoreCoordinatorUserAndErrorBlock)completion
{
    NSManagedObjectContext *mainQueueContext = CoreDataStoreCoordinator.sharedStoreCoordinator.mainManagedObjectContext;
    [mainQueueContext
        performBlock:^(void)
        {
            InstagramUser *selfUser = (InstagramUser *)[self
                managedObjectForResponse:response
                andEntityName:InstagramUserEntityName
                andContext:mainQueueContext
            ];
            [InstagramObjectMapper
                mapResponse:response
                toUser:selfUser
            ];
            selfUser.isSelf = @YES;
            
            BOOL isNewlyInserted = selfUser.objectID.isTemporaryID;
            
            NSError *error = [self
                saveContext:mainQueueContext
                andLogMessageIfError:@"Failed to cache self user."
            ];
            
            // Add saved context to dictionary
            
            if (isNewlyInserted)
            {
                [self
                    setObjectID:selfUser.objectID
                    forEntityName:selfUser.entity.managedObjectClassName
                    andID:selfUser.id
                ];
            }
            
            completion(selfUser, error);
        }
    ];
}

- (void)getSelfUserDetailsWithCompletion:(InstagramStoreCoordinatorUserAndErrorBlock)completion
{
    NSManagedObjectContext *workerQueueContext = [CoreDataStoreCoordinator.sharedStoreCoordinator spawnWorkerContext];
    [workerQueueContext
        performBlock:^(void)
        {
            NSFetchRequest *fetchRequest = [NSFetchRequest new];
            fetchRequest.resultType = NSManagedObjectResultType;
            [fetchRequest
                setEntity:[NSEntityDescription
                    entityForName:InstagramUserEntityName
                    inManagedObjectContext:workerQueueContext
                ]
            ];
            [fetchRequest setPredicate:
                [NSPredicate predicateWithFormat:
                    @"isSelf == YES"
                ]
            ];
            [fetchRequest setFetchLimit:SelfUserEntityLimit];
            
            NSError *error = nil;
            NSManagedObjectID *selfUserObjectID = [workerQueueContext
                executeFetchRequest:fetchRequest
                error:&error
            ].firstObject;
            
            NSManagedObjectContext *mainQueueContext = CoreDataStoreCoordinator.sharedStoreCoordinator.mainManagedObjectContext;
            [mainQueueContext
                performBlock:^(void)
                {
                    InstagramUser *selfUser = nil;
                    if (error)
                    {
                        NSLog( @"ERROR: Failed to fetch self user – %@", error.localizedDescription );
                    }
                    else
                    {
                        selfUser = (InstagramUser *)[workerQueueContext objectWithID:selfUserObjectID];
                    }
                    completion(selfUser,error);
                }
            ];
        }
    ];
}



/******************************************************************************/

#pragma mark - Self User Feed Method

/******************************************************************************/

- (void)cacheSelfUserFeedResponse:(NSArray *)response
    withCompletion:(InstagramStoreCoordinatorMediaAndErrorBlock)completion
{
    [self
        cacheMediaFeedResponse:response
        withCompletion:completion
    ];
}

- (void)getSelfUserFeedWithCompletion:(InstagramStoreCoordinatorMediaAndErrorBlock)completion
{
    NSManagedObjectContext *workerQueueContext = [CoreDataStoreCoordinator.sharedStoreCoordinator spawnWorkerContext];
    [workerQueueContext
        performBlock:^(void)
        {
            NSFetchRequest *fetchRequest = [NSFetchRequest new];
            fetchRequest.resultType = NSManagedObjectIDResultType;
            [fetchRequest
                setEntity:[NSEntityDescription
                    entityForName:InstagramMediaEntityName
                    inManagedObjectContext:workerQueueContext
                ]
            ];
            [fetchRequest setSortDescriptors:
                @[
                    [NSSortDescriptor
                        sortDescriptorWithKey:CreatedDateEntityAttributeName
                        ascending:YES
                    ]
                ]
            ];
            [fetchRequest setFetchBatchSize:MediaBatchSize];
            
            NSError *error = nil;
            NSArray *mediaObjectIDs = [workerQueueContext
                executeFetchRequest:fetchRequest
                error:&error
            ];
            
            NSManagedObjectContext *mainQueueContext = CoreDataStoreCoordinator.sharedStoreCoordinator.mainManagedObjectContext;
            [mainQueueContext
                performBlock:^(void)
                {
                    NSMutableArray *mediaArray = [NSMutableArray array];
                    
                    if (error)
                    {
                        NSLog( @"ERROR: Failed to fetch self user – %@", error.localizedDescription );
                    }
                    else
                    {
                        for (NSInteger i = 0; i < mediaObjectIDs.count; i++ )
                        {
                            NSManagedObjectID *mediaObjectID = mediaObjectIDs[i];
                            InstagramMedia *media = (InstagramMedia *)[mainQueueContext objectWithID:mediaObjectID];
                            [mediaArray addObject:media];
                        }
                    }
                    completion([NSArray arrayWithArray:mediaArray],error);
                }
            ];
        }
    ];
}

/******************************************************************************/

#pragma mark - General Media Feed Caching Methods

/******************************************************************************/

- (void)cacheMediaFeedResponse:(NSArray *)response
    withCompletion:(InstagramStoreCoordinatorMediaAndErrorBlock)completion
{
    NSManagedObjectContext *mainQueueContext = CoreDataStoreCoordinator.sharedStoreCoordinator.mainManagedObjectContext;
    [mainQueueContext
        performBlock:^(void)
        {
            // !!!
            //
            // When mapping the response to entities we need to keep track of a few things.
            //
            // First, we need to make sure that temporary user objects are not repeated.
            // Of the three types of entities we're inserting/updating, user objects are
            // the only ones that do not have to always be unique. The dictionary is used so
            // NSManagedObjects instances can be reused.
            //
            // Second, for media and comment objects, we just use an NSSet to track each
            // NSManagedObject instance, under the assumption that Instagram's API does not
            // return non-unique instances of media and comment objects.
            //
            // Third, we need to keep track of the user and comment relationships that are
            // associated with the media. Once the parsing is done, and the entities are
            // saved to the context, we then perform a refreshObject:mergeChanges: so that
            // strong inverse references between the media, and the user and comments, are
            // nulled since those objects are faulted back into the context.
            
            NSMutableDictionary *temporaryUsersByID = [NSMutableDictionary dictionary];
            
            NSMutableSet *temporaries   = [NSMutableSet set];
            NSMutableSet *relationships = [NSMutableSet set];
            
            // Declare block for handling user entity requests.
            
            InstagramObjectMapperUserEntityRequestHandler userEntityRequestHandler = ^InstagramUser *(NSDictionary *userResponse)
            {
                NSString *userID = [InstagramObjectMapper extractIDFromResponse:userResponse];
                InstagramUser *user = temporaryUsersByID[userID];

                if (user == nil)
                {
                    user = (InstagramUser *)[self
                        managedObjectForResponse:userResponse
                        andEntityName:InstagramUserEntityName
                        andContext:mainQueueContext
                    ];
                    
                    if (user.objectID.isTemporaryID)
                    {
                        temporaryUsersByID[userID] = user;
                        [temporaries addObject:user];
                    }
                    
                    [relationships addObject:user];
                }
                
                [InstagramObjectMapper
                    mapResponse:userResponse
                    toUser:user
                ];

                return user;
            };
            
            // Declare block for hanlding comment entity requests.
            
            InstagramObjectMapperCommentEntityRequestHandler commentEntityHandler = ^InstagramComment *(NSDictionary *commentResponse, BOOL asCaption)
            {
                InstagramComment *comment = (InstagramComment *)[self
                    managedObjectForResponse:commentResponse
                    andEntityName:InstagramCommentEntityName
                    andContext:mainQueueContext
                ];
                [InstagramObjectMapper
                    mapResponse:commentResponse
                    toComment:comment
                    asCaption:asCaption
                    withUserEntityRequestHandler:userEntityRequestHandler
                ];
                
                if (comment.objectID.isTemporaryID)
                {
                    [temporaries addObject:comment];
                }
                
                [relationships addObject:comment];
                return comment;
            };
            
            NSMutableArray *mediaArray = [NSMutableArray array];
            for (NSDictionary *mediaResponse in response)
            {
                InstagramMedia *media = (InstagramMedia *)[self
                    managedObjectForResponse:mediaResponse
                    andEntityName:InstagramMediaEntityName
                    andContext:mainQueueContext
                ];
                [InstagramObjectMapper
                    mapResponse:mediaResponse
                    toMedia:media
                    withUserEntityRequestHandler:userEntityRequestHandler
                    andCommentEntityRequestHandler:commentEntityHandler
                ];
                
                if (media.objectID.isTemporaryID)
                {
                    [temporaries addObject:media];
                }
                
                [mediaArray addObject:media];
            }
            
            NSError *error = [self
                saveContext:mainQueueContext
                andLogMessageIfError:@"Failed to cache self user."
            ];
        
            // Fault relationships back into context to remove strong inverse references
            
            for (NSManagedObject* relationship in relationships)
            {
                [mainQueueContext
                    refreshObject:relationship
                    mergeChanges:NO
                ];
                
                // Remove any temporaries if found during this first pass.
                
                if ([temporaries containsObject:relationship])
                {
                    [self setObjectByIdWithManagedObject:relationship];
                }
            }
            
            // Remove any relationships in temporaries and save what's left to the objectID map.
            
            [temporaries minusSet:relationships];
            for (NSManagedObject* temporary in temporaries)
            {
                [self setObjectByIdWithManagedObject:temporary];
            }
            
            completion([NSArray arrayWithArray:mediaArray],error);
        }
    ];
}



/******************************************************************************/

#pragma mark - Find and Insert Utility Method

/******************************************************************************/

- (NSManagedObject *)managedObjectForResponse:(NSDictionary *)response
    andEntityName:(NSString *)entityName
    andContext:(NSManagedObjectContext *)context
{
    NSManagedObject *managedObject = nil;
    NSString *id = [InstagramObjectMapper extractIDFromResponse:response];
    if (id)
    {
        NSManagedObjectID *mediaObjectID = [self
            objectIDForEntityName:entityName
            andID:id
        ];
        BOOL shouldInsertToContext = mediaObjectID == nil;
        if (shouldInsertToContext)
        {
            managedObject = [NSEntityDescription
                insertNewObjectForEntityForName:entityName
                inManagedObjectContext:context
            ];
        }
        else
        {
            managedObject = [context objectWithID:mediaObjectID];
        }
    }
    
    return managedObject;
}



/******************************************************************************/

#pragma mark - Context Saving Utility Method

/******************************************************************************/

- (NSError *)saveContext:(NSManagedObjectContext *)context
    andLogMessageIfError:(NSString *)message
{
    NSError *error = nil;
    BOOL didSaveFail = ![context save:&error];
    if (didSaveFail)
    {
        NSLog( @"ERROR: %@ – %@", message, error.localizedDescription );
    }
    
    [CoreDataStoreCoordinator.sharedStoreCoordinator saveToPersistentStore];
    
    return error;
}



/******************************************************************************/

#pragma mark - Object ID by ID Map Management Methods

/******************************************************************************/

- (void)setObjectByIdWithManagedObject:(NSManagedObject *)managedObject
{
    @synchronized(self)
    {
        if ([managedObject respondsToSelector:@selector(id)])
        {
            [self
                setObjectID:managedObject.objectID
                forEntityName:managedObject.entity.managedObjectClassName
                andID:[managedObject performSelector:@selector(id)]
            ];
        }
    }
}

- (void)setObjectID:(NSManagedObjectID *)objectID
    forEntityName:(NSString *)entityName
    andID:(NSString *)id
{
    @synchronized(self)
    {
        BOOL canSetObjectID = objectID && id && id.length > 0 && entityName && entityName.length > 0;
        if (canSetObjectID)
        {
            if (_objectIDsByIDByEntity == nil)
            {
                _objectIDsByIDByEntity = [NSMutableDictionary dictionary];
            }
            
            NSMutableDictionary *objectIDsByID = _objectIDsByIDByEntity[entityName];
            if (objectIDsByID == nil)
            {
                _objectIDsByIDByEntity[entityName] = [NSMutableDictionary dictionary];
                objectIDsByID = _objectIDsByIDByEntity[entityName];
            }
            objectIDsByID[id] = objectID;
        }
    }
}

- (NSManagedObjectID *)objectIDForEntityName:(NSString *)entityName
    andID:(NSString *)id
{
    @synchronized(self)
    {
        NSManagedObjectID *objectID = nil;
        BOOL canRetrieve = id && id.length > 0 && entityName && entityName.length > 0;
        if (canRetrieve)
        {
            objectID = _objectIDsByIDByEntity[entityName][id];
        }
        
        return objectID;
    }
}

@end
