//
//  InstagramModel.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "InstagramModel.h"

static NSString *const NullString = @"<null>";

@implementation InstagramModel

- (BOOL)isValueNonNull:(NSObject *)value
{
    return (value
        && (![value isEqual:[NSNull null]])
        && (![value isEqual:NullString])
    );
}
@end
