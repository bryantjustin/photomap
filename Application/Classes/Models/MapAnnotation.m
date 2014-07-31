//
//  MapAnnotation.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 13-07-31.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "MapAnnotation.h"

#import "InstagramMedia.h"
#import "InstagramUser.h"

@implementation MapAnnotation 

@synthesize coordinate = _coordinate;
@synthesize image = _image;
@synthesize media = _media;
@synthesize title = _title;

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
    _coordinate = coordinate;
}

- (void)setMedia:(InstagramMedia *)media
{
    _media = media;
    
    _title = media.user.username;
}

@end
