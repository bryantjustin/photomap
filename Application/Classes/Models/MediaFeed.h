//
//  MediaFeed.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstagramPagination.h"

@interface MediaFeed : NSObject
<
    Paging
>

+ (instancetype)feedWithMedia:(NSArray *)array;

@property (nonatomic,readonly,copy) NSArray *media;
@property (nonatomic,strong) InstagramPagination *pagination;

- (void)addMedia:(NSArray *)media;

- (void)updateWithLatestObjects:(NSArray *)objects;

- (void)updateWithNextPageOfObjects:(NSArray *)objects
    andPagination:(InstagramPagination *)pagination;

@end
