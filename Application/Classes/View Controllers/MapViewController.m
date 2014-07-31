//
//  MapViewController.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-26.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "InstagramMedia.h"
#import "MapViewController.h"
#import "MapAnnotation.h"
#import "MapAnnotationView.h"
#import "MediaFeed.h"
#import "MediaManager.h"
#import "MediaDetailViewController.h"

#define INTIAL_REGION_SPAN 0.03

@interface MapViewController ()

@property (nonatomic,weak) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController
{
    BOOL _didZoomInToUser;
    NSMutableDictionary *_annotationsByMediaID;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"PHOTOMAP"];
    [self prepareMap];
}

@synthesize feed = _feed;
- (void)setFeed:(MediaFeed *)feed
{
    _feed = feed;
    [self mapPhotos:_feed.media];
}
- (void)prepareMap
{
    self.mapView.delegate = self;
    
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setShowsBuildings:YES];
    [self.mapView setShowsPointsOfInterest:YES];
}

- (void)mapPhotos:(NSArray *)mediaArray
{
    for (int i = 0; i < mediaArray.count; i++)
    {
        InstagramMedia *media = mediaArray[i];
        
        BOOL shouldAnnotate = CLLocationCoordinate2DIsValid(media.location) && media.thumbnailURL;
        if (shouldAnnotate)
        {
            [MediaManager.sharedManager
                loadImageWithURL:media.thumbnailURL
                andCompletionBlock:^(UIImage *image)
                {
                    if (image)
                    {
                        MapAnnotation *mapAnnotation = _annotationsByMediaID[media.id];
                        if (mapAnnotation == nil)
                        {
                            mapAnnotation = [MapAnnotation new];
                            mapAnnotation.media = media;
                            mapAnnotation.image = image;
                            [mapAnnotation
                                setCoordinate:media.location
                            ];
                            [self.mapView addAnnotation:mapAnnotation];
                            _annotationsByMediaID[media.id] = mapAnnotation;
                        }
                    }
                }
            ];
        }
    }
}



/******************************************************************************/
#pragma mark -
#pragma mark MKMapViewDelegate
/******************************************************************************/

- (void)mapView:(MKMapView *)lmapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!_didZoomInToUser)
    {
        MKCoordinateRegion region;
        region.center = self.mapView.userLocation.coordinate;
        region.span = MKCoordinateSpanMake(INTIAL_REGION_SPAN, INTIAL_REGION_SPAN);
        region = [self.mapView regionThatFits:region];
        [self.mapView setRegion:region animated:YES];
        
        _didZoomInToUser = YES;
    }
}



/******************************************************************************/
#pragma mark -
#pragma mark MKMapViewDelegated
/******************************************************************************/

- (MKAnnotationView *)mapView:(MKMapView *)lmapView viewForAnnotation:(id <MKAnnotation>)annotation;
{
    MapAnnotationView *annotationView = nil;
    if (annotation != self.mapView.userLocation)
    {
        static NSString *viewId = @"com.bryantjustin.photomap.annotation";
        annotationView = (MapAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:viewId];
        if ( annotationView == nil )
        {
            annotationView = [[MapAnnotationView alloc]
                initWithAnnotation:annotation
                reuseIdentifier:viewId
            ];
        }
        else
        {
            annotationView.annotation = annotation;
        }

        annotationView.enabled = YES;
    }

    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:MapAnnotationView.class])
    {
        MapAnnotationView *mapAnnotationView = (MapAnnotationView *)view;
        [self.navigationController
            pushViewController:[MediaDetailViewController
                controllerWithMedia:mapAnnotationView.mapAnnotation.media
            ]
            animated:YES
        ];
    }
}

@end
