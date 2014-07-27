//
//  KeychainManager.m
//  Photomap
//
//  Created by Bryant Balatbat on 2014-07-26.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <FXKeychain/FXKeychain.h>
#import "KeychainManager.h"

static NSString *const KeyChainUserDefaultsHasRunKey = @"com.bryantjustin.photomap.hasRun";

@implementation KeychainManager
{
    FXKeychain *_keychain;
}



/******************************************************************************/

#pragma mark - Singleton reference

/******************************************************************************/

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken = 0;
    static KeychainManager *instance = nil;
    
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

- (FXKeychain *)keychain
{
    @synchronized(self)
    {
        if (!_keychain)
        {
            _keychain = [FXKeychain defaultKeychain];
        }

        return _keychain;
    }
}

- (BOOL)hasRun
{
    return [NSUserDefaults.standardUserDefaults boolForKey:KeyChainUserDefaultsHasRunKey];
}

- (void)setHasRun
{
    [NSUserDefaults.standardUserDefaults
        setBool:YES
        forKey:KeyChainUserDefaultsHasRunKey
    ];
    
    [NSUserDefaults.standardUserDefaults synchronize];
}



/******************************************************************************/

#pragma mark - Storage methods

/******************************************************************************/

- (void)setString:(NSString *)string
    forKey:(NSString *)key
{
    @synchronized(self)
    {
        if (string)
        {
            [self.keychain
                setObject:string
                forKey:key
            ];
        
            [NSUserDefaults.standardUserDefaults
                setBool:YES
                forKey:key
            ];
            [NSUserDefaults.standardUserDefaults synchronize];
        }
        else
        {
            [self removeItemForKey:key];
        }
    }
}

- (NSString *)stringForKey:(NSString *)key
{
    @synchronized(self)
    {
        NSString *string = nil;
        
        // Check if the property has been set in user defaults.
        // This prevents unnecessary user prompts for keychain access.
        // Keychain access prompt is specific to OSX keychain API.
        
        BOOL hasSetKey = [NSUserDefaults.standardUserDefaults boolForKey:key];
        if (hasSetKey)
        {
            string = [self.keychain objectForKey:key];
        }

        return string;
    }
}

- (void)removeItemForKey:(NSString *)key
{
    @synchronized(self)
    {
        [self.keychain removeObjectForKey:key];
        
        [NSUserDefaults.standardUserDefaults removeObjectForKey:key];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
}



/******************************************************************************/

#pragma mark - Reset keychain methods

/******************************************************************************/

- (void)resetKeychainIfNecessary
{
    // Clear key chain on first run in case of previous installation

    if (!self.hasRun)
    {
        [self resetKeychain];
        [self setHasRun];
    }
}

- (void)resetKeychain
{
    [self.keychain removeObjectForKey:InstagramAccessTokenKeychainKey];
}

@end
