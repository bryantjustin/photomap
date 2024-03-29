//
//  MapAnnotationView.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 13-07-31.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "MapAnnotationView.h"

#import "MediaManager.h"

// todo - update these values to customise the map marker

// sample files replace with real ones
#define MAP_MARKER_BACKGROUND_FILE_NAME     @"annotation-pin"
#define MAP_MARKER_MASK_FILE_NAME           @"sample-map-thumbnail-mask.png"

/* the difference between the center point of the image and the point on the
    image that points to the location (postive values move the marker down and to
    the right
*/
#define MAP_MARKER_CENTER_OFFSET_X          0
#define MAP_MARKER_CENTER_OFFSET_Y          -34.

// the offset of the mask from the image
#define MAP_MARKER_MASK_BASE_OFFSET_X       5.0
#define MAP_MARKER_MASK_BASE_OFFSET_Y       5.5

static CGFloat const Radius = 25.0;
static CGRect  const AnnotationFrame = { 0.0, 0.0, Radius * 2, Radius * 2 };

@interface MapAnnotationView ()

@property (nonatomic,readonly) UIImageView *imageView;

@end

@implementation MapAnnotationView

@synthesize imageView = _imageView;
- (UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc]
            initWithFrame:AnnotationFrame
        ];
        _imageView.layer.cornerRadius   = Radius;
        _imageView.layer.masksToBounds  = YES;
        
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    [self setNeedsLayout];
}

- (MapAnnotation*)mapAnnotation
{
    return mapAnnotation;
}

- (void)setMapAnnotation:(MapAnnotation*)_mapAnnotation
{
    mapAnnotation = _mapAnnotation;
    
    [self setImage:mapAnnotation.image];
    [self setCenterOffset:CGPointMake(-Radius/2, -Radius/2)];
    [self setFrame:AnnotationFrame];
}


- (id)initWithAnnotation:(id<MKAnnotation>)annotation
    reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])
    {
        [self setMapAnnotation:annotation];
    }
    
    return self;
}

@end