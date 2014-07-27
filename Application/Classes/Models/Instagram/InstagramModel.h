//
//  InstagramModel.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramModel : NSObject

/**
 *  Creates a model instance based on a response.
 *
 *  @param response NSDictionary of the response.
 *
 *  @return InstagramModel instance.
 */
+ (instancetype)modelWithResponse:(NSDictionary *)response;

/**
 *  Determines if a value is non null. A value is considered
 *  non null if and only if:
 *
 *      * value != nil AND
 *      * ![value isEqual:[NSNull null]])
 *      * (![value isEqual:@"<null>"])
 *
 *  @param value NSObject value to check.
 *
 *  @return BOOL that determines that a value is non null.
 */
- (BOOL)isValueNonNull:(NSObject *)value;

@end
