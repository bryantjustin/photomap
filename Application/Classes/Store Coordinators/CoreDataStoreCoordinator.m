//
//  CoreDataStoreCoordinator.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "CoreDataStoreCoordinator.h"

static NSString *const StoreURL             = @"com.bryantjustin.com.photomap.sqlite";
static NSString *const StoreModelResource   = @"PhotoMapModel";
static NSString *const StoreModelExtension  = @"momd";



/******************************************************************************/

#pragma mark - Class Extension

/******************************************************************************/

@interface CoreDataStoreCoordinator ()



/******************************************************************************/

#pragma mark - Properties declaration

/******************************************************************************/

@property (readonly) NSManagedObjectContext         *privateManagedObjectContext;
@property (readonly) NSManagedObjectModel           *managedObjectModel;
@property (readonly) NSPersistentStoreCoordinator   *persistentStoreCoordinator;

@end



/******************************************************************************/

#pragma mark - Class Implementation

/******************************************************************************/

@implementation CoreDataStoreCoordinator



/******************************************************************************/

#pragma mark - Singleton Reference

/******************************************************************************/

+ (instancetype)sharedStoreCoordinator
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

#pragma mark - Synthesized properties

/******************************************************************************/

@synthesize mainManagedObjectContext        = _mainManagedObjectContext;
@synthesize privateManagedObjectContext     = _privateManagedObjectContext;
@synthesize managedObjectModel              = _managedObjectModel;
@synthesize persistentStoreCoordinator      = _persistentStoreCoordinator;



/******************************************************************************/

#pragma mark - Properties

/******************************************************************************/

- (NSManagedObjectContext *)privateManagedObjectContext
{
    if (_privateManagedObjectContext == nil)
    {
        _privateManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _privateManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }

    return _privateManagedObjectContext;
}

- (NSManagedObjectContext *)mainManagedObjectContext
{
    if (_mainManagedObjectContext == nil)
    {
        _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainManagedObjectContext.parentContext = self.privateManagedObjectContext;
    }
    
    return _mainManagedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil)
    {
        NSURL *modelURL = [NSBundle.mainBundle
            URLForResource:StoreModelResource
            withExtension:StoreModelExtension
        ];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator == nil)
    {
        NSURL *storeURL = [self.applicationSupportDirectory URLByAppendingPathComponent:StoreURL];
        NSError *error = nil;
        NSDictionary* options =
        @{
            NSMigratePersistentStoresAutomaticallyOption    : @(YES),
            NSInferMappingModelAutomaticallyOption          : @(YES)
        };
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
            initWithManagedObjectModel:self.managedObjectModel
        ];
        
        if (![_persistentStoreCoordinator
                addPersistentStoreWithType:NSSQLiteStoreType
                configuration:nil
                URL:storeURL
                options:options
                error:&error])
        {
        
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. 
             You should not use this function in a shipping application, although it may 
             be useful during development.
             
             Typical reasons for an error here include:
             * The persistent store is not accessible;
             * The schema for the persistent store is incompatible with current managed 
               object model.
             
             Check the error message to determine what the actual problem was.
             
             
             If the persistent store is not accessible, there is typically something wrong 
             with the file path. Often, a file URL is pointing into the application's 
             resources directory instead of a writeable directory.
             
             If you encounter schema incompatibility errors during development, you can 
             reduce their frequency by:
             
             * Simply deleting the existing store:
               [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
             
             * Performing automatic lightweight migration by passing the following 
               dictionary as the options parameter:
               @{
                   NSMigratePersistentStoresAutomaticallyOption:@YES, 
                   NSInferMappingModelAutomaticallyOption:@YES
                }
             
             Lightweight migration will only work for a limited set of schema changes; 
             consult "Core Data Model Versioning and Data Migration Programming Guide" 
             for details.
             
             */
            NSLog(@"ERROR: Unresolved error: %@", error.localizedDescription );
            NSLog(@"ERROR: Error data: %@", error.userInfo);
            
            abort();
        
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationSupportDirectory
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *applicationSupportDirectoryPath = [
        NSSearchPathForDirectoriesInDomains(
            NSApplicationSupportDirectory,
            NSUserDomainMask,
            YES
        )
        lastObject
    ];
    
    BOOL doesDirectoryNeedToBeCreated = ![manager fileExistsAtPath:applicationSupportDirectoryPath];
    if(doesDirectoryNeedToBeCreated)
    {
        __autoreleasing NSError *error;
        BOOL didCreateSuccessfully = [manager
            createDirectoryAtPath:applicationSupportDirectoryPath
            withIntermediateDirectories:NO
            attributes:nil
            error:&error
        ];
        
        
        if(!didCreateSuccessfully)
        {
            NSLog(@"ERROR app support: %@", error);
            exit(0);
        }
    }

    return [manager
        URLsForDirectory:NSApplicationSupportDirectory
        inDomains:NSUserDomainMask
    ].lastObject;
}



/******************************************************************************/

#pragma mark - Context spawning methods

/******************************************************************************/

- (NSManagedObjectContext *)spawnWorkerContext
{
    // Creates a new context that is associated with a background thread.
    // Since this new thread has the singleton's private managed context as it's
    // parent, it's data will be as current as the parent context.
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc]
        initWithConcurrencyType:NSPrivateQueueConcurrencyType
    ];
    context.parentContext = self.mainManagedObjectContext;

    return context;
}




/******************************************************************************/

#pragma mark - Context save method

/******************************************************************************/

- (void)saveToPersistentStore
{
    [self.privateManagedObjectContext
        performBlockAndWait:^(void)
        {
            NSError *error = nil;
            BOOL didSaveFail = ![self.privateManagedObjectContext save:&error];
            if (didSaveFail)
            {
                NSLog( @"ERROR: Save to persistent store failed. – %@", error.localizedDescription );
            }
        }
    ];
}

/******************************************************************************/

#pragma mark - Reset method

/******************************************************************************/

- (void)resetManager
{
    // TODO: Refactor file management.
    
    for (NSPersistentStore *persistentStore in self.persistentStoreCoordinator.persistentStores)
    {
        NSError *error = nil;
        NSURL *persistentStoreURL = persistentStore.URL;
    
        [self.persistentStoreCoordinator
            removePersistentStore:persistentStore
            error:&error
        ];
        
        if (error)
        {
            NSLog ( @"ERROR: Remove persistent store failed: %@", error.localizedDescription );
        }
        
        [NSFileManager.defaultManager
            removeItemAtPath:persistentStoreURL.path
            error:&error
        ];
        
        if (error)
        {
            NSLog ( @"ERROR: Remove file failed: %@", error.localizedDescription );
        }
    }
    
    _managedObjectModel = nil;
    _privateManagedObjectContext = nil;
    _persistentStoreCoordinator = nil;
}

@end
