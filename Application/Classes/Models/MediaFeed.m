//
//  MediaFeed.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "MediaFeed.h"

@implementation MediaFeed
{
    NSMutableArray *_media;
}

+ (instancetype)feedWithMedia:(NSArray *)media
{
    return [[self alloc] initWithMedia:media];
}

- (instancetype)initWithMedia:(NSArray *)media
{
    if (self = [super init])
    {
        [self addMedia:media];
    }
    
    return self;
}

- (void)addMedia:(NSArray *)media
{
    if (_media == nil)
    {
        _media = [NSMutableArray array];
    }
    
    [_media addObjectsFromArray:media];
    _media = [NSMutableArray arrayWithArray:[self sortMedia:_media]];
}

- (NSArray *)sortMedia:(NSArray *)media
{
    return [media
        sortedArrayUsingDescriptors:
        @[
            [NSSortDescriptor
                sortDescriptorWithKey:@"createdDate"
                ascending:NO
            ]
        ]
    ];
}

- (void)updateWithLatestObjects:(NSArray *)objects
{
    if (_media == nil)
    {
        [self addMedia:objects];
    }
    else
    {
        NSMutableArray *updatedArray = [NSMutableArray arrayWithArray:objects];
        [updatedArray addObjectsFromArray:_media];
        _media = [NSMutableArray arrayWithArray:[self sortMedia:updatedArray]];
        
    }
    
    [NSNotificationCenter.defaultCenter
        postNotificationName:kFeedDidUpdate
        object:self
        userInfo:@{UpdatedObjectsKey:objects}
    ];
}

- (void)updateWithNextPageOfObjects:(NSArray *)objects
    andPagination:(InstagramPagination *)pagination
{
    [self setPagination:pagination];
    [self addMedia:objects];
    
    [NSNotificationCenter.defaultCenter
        postNotificationName:kFeedDidUpdate
        object:self
        userInfo:@{UpdatedObjectsKey:objects}
    ];
}

@end
