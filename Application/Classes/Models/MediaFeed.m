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
    _media = [NSMutableArray arrayWithArray:[self sortMedia]];
    
}

- (NSArray *)sortMedia
{
    return [_media
        sortedArrayUsingDescriptors:
        @[
            [NSSortDescriptor
                sortDescriptorWithKey:@"createdDate"
                ascending:NO
            ]
        ]
    ];
}

@end
