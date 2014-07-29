//
//  InstagramManager.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "InstagramManager.h"

#import "InstagramPagination.h"
#import "InstagramObjectMapper.h"
#import "InstagramService.h"
#import "InstagramStoreCoordinator.h"

@interface InstagramManager ()

@property (readonly) InstagramService           *service;
@property (readonly) InstagramStoreCoordinator  *storeCoordinator;

@end

@implementation InstagramManager

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



/******************************************************************************/

#pragma mark - Init Methods

/******************************************************************************/

- (instancetype)init
{
    if (self = [super init])
    {
        _service = InstagramService.sharedService;
        _storeCoordinator = InstagramStoreCoordinator.sharedStoreCoordinator;
    }
    
    return self;
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

- (void)getSelfUserFeedWithSuccess:(InstagramManagerMediaBlock)success
    failure:(InstagramManagerErrorBlock)failure
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
                cacheSelfUserFeedResponse:dataResponse
                withCompletion:^(NSArray *media, NSError *error)
                {
                    if (error == nil)
                    {
                        success(media,pagination);
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

@end
