//
//  UserModel.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "UserModel.h"
#import "KeychainManager.h"

@implementation UserModel

+ (instancetype)sharedModel
{
    static dispatch_once_t onceToken = 0;
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

@synthesize accessToken = _accessToken;

- (void)setAccessToken:(NSString *)accessToken
{
    @synchronized(self)
    {
        [KeychainManager.sharedManager
            setString:accessToken
            forKey:InstagramAccessTokenKeychainKey
        ];
    }
}

- (NSString *)accessToken
{
    @synchronized(self)
    {
        return [KeychainManager.sharedManager stringForKey:InstagramAccessTokenKeychainKey];
    }
}

- (BOOL)hasAccessToken
{
    return self.accessToken != nil;
}

@end
