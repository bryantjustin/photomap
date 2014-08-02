//
//  MapViewController.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-26.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "ViewController.h"

@class MediaFeed;

@interface MapViewController : ViewController
<
    MKMapViewDelegate
>

@property (nonatomic,strong) MediaFeed *feed;

@end
