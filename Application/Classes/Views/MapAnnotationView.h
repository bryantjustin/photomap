//
//  MapAnnotationView.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 13-07-31.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapAnnotation.h"

@interface MapAnnotationView : MKAnnotationView
{
    MapAnnotation* mapAnnotation;
    UIImageView *imageView;
}

@property (strong) MapAnnotation* mapAnnotation;


@end
