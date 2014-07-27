//
//  InstagramService.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-26.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramService : NSObject

+ (instancetype)sharedService;

- (void)login;

- (BOOL)application:(UIApplication *)application
    openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
    annotation:(id)annotation;

- (void)getUserDetails;
//WithSuccess:
//    (void (^)(InstagramUser *userDetail))success
//    failure:(InstagramFailureBlock)failure

//- (void)getSelfFeedWithSuccess:(InstagramMediaBlock)success
//    failure:(InstagramFailureBlock)failure;
//
//- (void)getSelfFeedWithCount:(NSInteger)count maxId:(NSString *)maxId
//    success:(InstagramMediaBlock)success
//    failure:(InstagramFailureBlock)failure;

@end
