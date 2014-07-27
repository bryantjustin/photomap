//
//  KeychainManager.h
//  Photomap
//
//  Created by Bryant Balatbat on 2014-07-26.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainManager : NSObject

/**
 *  Singleton reference.
 *
 *  @return KeychainManager instance.
 */
+ (instancetype)sharedManager;

/**
 *  After it inserts the value in the keychain, it will then set the user defaults
 *  with the same key so that the getter will know that a value has been set.
 *
 *  @param  string   NSString to be stored in the keychain.
 *  @param  key      NSString key used to retrieve.
 */
- (void)setString:(NSString *)string
    forKey:(NSString *)key;

/**
 *  This will pull from the keychain but iff that value has been set previously
 *  according to User Defaults. This prevents unnecessary keychain access prompts.
 *
 *  @param  key     NSString key used to retrieve the stored string.
 *
 *  @return NSString that was stored in the keychain.
 */
- (NSString *)stringForKey:(NSString *)key;

/**
 *  Removes the value stored with the key from the keychain and defaults.
 *
 *  @param  key     NSString key whose value will be removed from keychain and defaults.
 */
- (void)removeItemForKey:(NSString *)key;

/**
 *  Resets the keychain is the app is running for the first time.
 */
- (void)resetKeychainIfNecessary;

/**
 *  Resets the keychain completely.
 */
- (void)resetKeychain;

@end
