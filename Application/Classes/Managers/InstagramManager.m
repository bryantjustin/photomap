//
//  InstagramManager.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "InstagramManager.h"

#import "InstagramMedia.h"
#import "InstagramPagination.h"
#import "InstagramObjectMapper.h"
#import "InstagramService.h"
#import "InstagramStoreCoordinator.h"
#import "InstagramTag.h"
#import "MediaFeed.h"

@interface InstagramManager ()

@end

@implementation InstagramManager
{
    InstagramService            *_service;
    InstagramStoreCoordinator   *_storeCoordinator;
}

/******************************************************************************/

#pragma mark - Singleton Reference

/******************************************************************************/

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken = 0ul;
    static id instance = nil;
    dispatch_once(
        &onceToken,
        ^(void)
        {
            instance = [self new];
        }
    );
    
    return instance;
}



/******************************************************************************/

#pragma mark - Properties

/******************************************************************************/

- (BOOL)requiresAccess
{
    return !_service.hasAccessToken;
}

- (BOOL)shouldUseCache
{
    return !AFNetworkReachabilityManager.sharedManager.isReachable;
}

/******************************************************************************/

#pragma mark - Init Methods

/******************************************************************************/

- (instancetype)init
{
    if (self = [super init])
    {
        _service            = InstagramService.defaultService;
        _storeCoordinator   = InstagramStoreCoordinator.defaultStoreCoordinator;
        
        [self prepareToObserveReachabilityStatus];
    }
    
    return self;
}

- (void)prepareToObserveReachabilityStatus
{
    [AFNetworkReachabilityManager.sharedManager startMonitoring];
    [AFNetworkReachabilityManager.sharedManager
        setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
        {
            // TODO: Handle internet connection.
        }
    ];
}

/******************************************************************************/

#pragma mark - Login Methods

/******************************************************************************/

- (void)login
{
    [_service login];
}

- (BOOL)application:(UIApplication *)application
    openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
    annotation:(id)annotation
{
    return [_service
        application:application
        openURL:url
        sourceApplication:sourceApplication
        annotation:annotation
    ];
}



/******************************************************************************/

#pragma mark - Initialize Manager

/******************************************************************************/

- (void)initializeManagerWithCompletion:(InstagramManagerErrorBlock)completion
{
    [_storeCoordinator
        initializeByFetchingManagedObjectIDsWithCompletionBlock:^(NSError *error)
        {
            if (error)
            {
                NSLog( @"ERROR: Failed to initialize store – %@.", error.localizedDescription );
            }
            
            completion(error);
        }
    ];
}



/******************************************************************************/

#pragma mark - Get Self User Details Method

/******************************************************************************/

- (void)getSelfUserDetailsWithSuccess:(InstagramManagerUserBlock)success
    failure:(InstagramManagerErrorBlock)failure;
{
    [_service
        getSelfUserDetailsWithSuccess:^(id dataResponse)
        {
            [_storeCoordinator
                cacheSelfUserDetailsResponse:dataResponse
                withCompletion:^(InstagramUser *user, NSError *error)
                {
                    if (error == nil)
                    {
                        success(user);
                    }
                    else
                    {
                        failure(error);
                    }
                }
            ];
        }
        failure:^(NSError *error)
        {
            failure(error);
        }
    ];
}

- (void)getSelfUserFeedWithSuccess:(InstagramManagerMediaFeedBlock)success
    failure:(InstagramManagerErrorBlock)failure
{
    if (self.shouldUseCache)
    {
        [_storeCoordinator
            getSelfUserFeedWithCompletion:^(NSArray *media, NSError *error)
            {
                if (error == nil)
                {
                    MediaFeed *feed = [MediaFeed feedWithMedia:media];
                    success(feed);
                }
                else
                {
                    failure(error);
                }
            }
        ];
    }
    else
    {
        [_service
            getSelfUserFeedWithSuccess:^(id dataResponse, id paginationResponse)
            {
                InstagramPagination *pagination = [InstagramPagination new];
                [InstagramObjectMapper
                    mapResponse:paginationResponse
                    toPagination:pagination
                ];
                
                [_storeCoordinator
                    cacheMediaArrayResponse:dataResponse
                    withCompletion:^(NSArray *media, NSError *error)
                    {
                        if (error == nil)
                        {
                            MediaFeed *feed = [MediaFeed feedWithMedia:media];
                            feed.pagination = pagination;
                            success(feed);
                        }
                        else
                        {
                            failure(error);
                        }
                    }
                ];
            }
            failure:^(NSError *error)
            {
                failure(error);
            }
        ];
    }
}

- (void)getLatestForMediaFeed:(MediaFeed *)feed
    success:(InstagramManagerMediaFeedBlock)success
    failure:(InstagramManagerErrorBlock)failure;
{
    if (AFNetworkReachabilityManager.sharedManager.isReachable)
    {
        InstagramMedia *media = feed.media.firstObject;
        [_service
            getLatestSelfUserFeedWithMinID:media.id
            success:^(id dataResponse)
            {
                [_storeCoordinator
                    cacheMediaArrayResponse:dataResponse
                    withCompletion:^(NSArray *media, NSError *error)
                    {
                        if (error == nil)
                        {
                            [feed updateWithLatestObjects:media];
                            success(feed);
                        }
                        else
                        {
                            failure(error);
                        }
                    }
                ];
            }
            failure:^(NSError *error)
            {
                failure(error);
            }
        ];
    }
}

- (void)getNextPageForFeed:(id<Paging>)pagingFeed
    success:(InstagramManagerMediaFeedBlock)success
    failure:(InstagramManagerErrorBlock)failure
{
    if (AFNetworkReachabilityManager.sharedManager.isReachable)
    {
        [_service
            getNextPageForFeed:pagingFeed
            success:^(id dataResponse, id paginationResponse)
            {
                InstagramPagination *pagination = [InstagramPagination new];
                [InstagramObjectMapper
                    mapResponse:paginationResponse
                    toPagination:pagination
                ];
                
                [_storeCoordinator
                    cacheMediaArrayResponse:dataResponse
                    withCompletion:^(NSArray *media, NSError *error)
                    {
                        if (error == nil)
                        {
                            [pagingFeed
                                updateWithNextPageOfObjects:media
                                andPagination:pagination
                            ];
                            success(pagingFeed);
                        }
                        else
                        {
                            failure(error);
                        }
                    }
                ];
            }
            failure:^(NSError *error)
            {
                failure(error);
            }
        ];
    }
}

- (void)getTagsForQuery:(NSString *)query
    success:(InstagramManagerTagsBlock)success failure:(InstagramManagerErrorBlock)failure
{
    if (AFNetworkReachabilityManager.sharedManager.isReachable)
    {
        [_service
            getTagsForQuery:query
            success:^(id dataResponse)
            {
                NSArray *dataResponseAsArray = dataResponse;
                NSMutableArray *mutableTags = [NSMutableArray arrayWithCapacity:dataResponseAsArray.count];
                
                for(int i = 0; i <  dataResponseAsArray.count; i++)
                {
                    InstagramTag *tag = [InstagramTag new];
                    [InstagramObjectMapper
                        mapResponse:dataResponseAsArray[i]
                        toTag:tag
                    ];
                    [mutableTags addObject:tag];
                }
                
                success([NSArray arrayWithArray:mutableTags]);
            }
            failure:^(NSError *error)
            {
                failure(error);
            }
        ];
    }
    else
    {
        success(nil);
    }
}

@end
