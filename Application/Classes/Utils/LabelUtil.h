//
//  LabelUtil.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-08-02.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LabelUtil : NSObject

+ (CGFloat)heightForRowWithString:(NSString *)string
    font:(UIFont *)font
    width:(CGFloat)width
    padding:(CGFloat)padding;

@end
