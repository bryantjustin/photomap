//
//  MediaFeed.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InstagramPagination;

@interface MediaFeed : NSObject

+ (instancetype)feedWithMedia:(NSArray *)array;

@property (readonly,copy) NSArray *media;
@property (strong) InstagramPagination *pagination;

- (void)addMedia:(NSArray *)media;

@end
