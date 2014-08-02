//
//  LabelUtil.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-08-02.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "LabelUtil.h"

@implementation LabelUtil

+ (CGFloat)heightForRowWithString:(NSString *)string
    font:(UIFont *)font
    width:(CGFloat)width
    padding:(CGFloat)padding
{
    if (string == nil)
    {
        return padding;
    }
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
        initWithString:string
        attributes:@{NSFontAttributeName:font}
    ];
    
    UILabel *label = [UILabel new];
    [label setNumberOfLines:0];
    [label setAttributedText:attributedString];
    CGSize size = [label sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height + padding; ;
}

@end
