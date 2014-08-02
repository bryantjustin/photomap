//
//  InstagramManager.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstagramPagination.h"

@class InstagramUser;
@class InstagramMedia;
@class InstagramComment;
@class InstagramTag;

@class MediaFeed;

typedef void (^InstagramManagerErrorBlock)      (NSError *error);
typedef void (^InstagramManagerUserBlock)       (InstagramUser *user);
typedef void (^InstagramManagerMediaFeedBlock)  (MediaFeed *feed);
typedef void (^InstagramManagerCommentBlock)    (NSArray *comments);
typedef void (^InstagramManagerTagsBlock)       (NSArray *tags);

@interface InstagramManager : NSObject

+ (instancetype)sharedManager;

@property (readonly) BOOL requiresAccess;

- (void)login;

- (BOOL)application:(UIApplication *)application
    openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
    annotation:(id)annotation;

- (void)initializeManagerWithCompletion:(InstagramManagerErrorBlock)completion;

- (void)getSelfUserDetailsWithSuccess:(InstagramManagerUserBlock)success
    failure:(InstagramManagerErrorBlock)error;

- (void)getSelfUserFeedWithSuccess:(InstagramManagerMediaFeedBlock)success
    failure:(InstagramManagerErrorBlock)failure;

- (void)getLatestForMediaFeed:(MediaFeed *)feed
    success:(InstagramManagerMediaFeedBlock)success
    failure:(InstagramManagerErrorBlock)failure;

- (void)getNextPageForFeed:(id<Paging>)pagingFeed
    success:(InstagramManagerMediaFeedBlock)success
    failure:(InstagramManagerErrorBlock)failure;

- (void)getTagsForQuery:(NSString *)query
    success:(InstagramManagerTagsBlock)success
    failure:(InstagramManagerErrorBlock)failure;

- (void)getMediaFeedForTag:(InstagramTag *)tag
    success:(InstagramManagerMediaFeedBlock)success
    failure:(InstagramManagerErrorBlock)failure;

@end
