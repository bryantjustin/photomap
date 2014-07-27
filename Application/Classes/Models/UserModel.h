//
//  UserModel.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

+ (instancetype)sharedModel;

@property (copy) NSString *accessToken;
@property (readonly) BOOL hasAccess;

@end
