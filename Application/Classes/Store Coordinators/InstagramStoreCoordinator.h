//
//  InstagramStoreCoordinator.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InstagramUser;
@class InstagramMedia;
@class InstagramComment;
@class InstagramPagination;

typedef void (^InstagramStoreCoordinatorErrorBlock)             (NSError *error);
typedef void (^InstagramStoreCoordinatorUserAndErrorBlock)      (InstagramUser *user, NSError *error);
typedef void (^InstagramStoreCoordinatorMediaAndErrorBlock)     (NSArray *media, NSError *error);
typedef void (^InstagramStoreCoordinatorCommentandErrorBlock)   (NSArray *comments, NSError *error);

@interface InstagramStoreCoordinator : NSObject

/**
 *  Singleton reference to the store coordinator.
 *
 *  @return InstagramStoreCoordinator instance.
 */
+ (instancetype)defaultStoreCoordinator;


/**
 *  Fetches NSManagedObjectIDs of all entities and stores them in dictionaries for each entity.
 *  Perform this fetch before any caching is performed. This would speed up determining if an
 *  object already exists by matching its object id in the dictionary. Storing NSManagedObjectIDs
 *  in memory should be pretty insignificant even with a ton of objects.
 *
 *  @param completion InstagramStoreCoordinatorErrorBlock completion block
 */
- (void)initializeByFetchingManagedObjectIDsWithCompletionBlock:(InstagramStoreCoordinatorErrorBlock)completion;

/**
 *  Cache self user details data response.
 *
 *  @param response   NSDictionary data response
 *  @param completion InstagramStoreCoordinatorUserAndErrorBlock completion block
 */
- (void)cacheSelfUserDetailsResponse:(NSDictionary *)response
    withCompletion:(InstagramStoreCoordinatorUserAndErrorBlock)completion;

/**
 *  Retrieves the stored InstagramUser object associated with the authenticated user.
 *
 *  @param completion InstagramStoreCoordinatorUserAndErrorBlock completion block
 */
- (void)getSelfUserDetailsWithCompletion:(InstagramStoreCoordinatorUserAndErrorBlock)completion;

/**
 *  Cache self user feed details data response.
 *
 *  @param response   NSDictionary data response
 *  @param completion InstagramStoreCoordinatorMediaAndErrorBlock completion block
 */
- (void)cacheSelfUserFeedResponse:(NSDictionary *)response
    withCompletion:(InstagramStoreCoordinatorMediaAndErrorBlock)completion;

/**
 *  Retrieves the stored InstagramMedia feed associated with the authenticated user.
 *
 *  @param completion InstagramStoreCoordinatorMediaAndErrorBlock completion block
 */
- (void)getSelfUserFeedWithCompletion:(InstagramStoreCoordinatorMediaAndErrorBlock)completion;

@end
