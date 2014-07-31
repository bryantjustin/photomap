//
//  MapAnnotation.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 13-07-31.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class InstagramMedia;

@interface MapAnnotation : NSObject<MKAnnotation>

@property (nonatomic,strong) InstagramMedia *media;
@property (nonatomic,strong) UIImage *image;

@property (nonatomic, readonly, copy) NSString *title;

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate;


@end
