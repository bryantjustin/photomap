//
//  InstagramService.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-26.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InstagramService.h"
#import "InstagramPagination.h"

typedef void (^InstagramServiceErrorBlock)                      (NSError *error);
typedef void (^InstagramServiceDataResponseBlock)               (id dataResponse);
typedef void (^InstagramServiceDataAndPaginationResponseBlock)  (id dataResponse, id paginationResponse);

@interface InstagramService : NSObject

/**
 *  Singleton reference.
 *
 *  @return InstagramService instance.
 */
+ (instancetype)defaultService;

@property (copy) NSString *accessToken;
@property (readonly) BOOL hasAccessToken;

- (void)login;

- (BOOL)application:(UIApplication *)application
    openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
    annotation:(id)annotation;

- (void)getSelfUserDetailsWithSuccess:(InstagramServiceDataResponseBlock)success
    failure:(InstagramServiceErrorBlock)failure;

- (void)getSelfUserFeedWithSuccess:(InstagramServiceDataAndPaginationResponseBlock)success
    failure:(InstagramServiceErrorBlock)failure;

- (void)getLatestSelfUserFeedWithMinID:(NSString *)minID
    success:(InstagramServiceDataResponseBlock)success
    failure:(InstagramServiceErrorBlock)failure;

- (void)getNextPageForFeed:(id<Paging>)pagingFeed
    success:(InstagramServiceDataAndPaginationResponseBlock)success
    failure:(InstagramServiceErrorBlock)failure;

- (void)getTagsForQuery:(NSString *)query
    success:(InstagramServiceDataResponseBlock)success
    failure:(InstagramServiceErrorBlock)failure;

- (void)getMediaFeedForTag:(NSString *)tag
    success:(InstagramServiceDataAndPaginationResponseBlock)success
    failure:(InstagramServiceErrorBlock)failure;

@end
