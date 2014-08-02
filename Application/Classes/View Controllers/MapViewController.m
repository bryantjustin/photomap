//
//  MapViewController.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-26.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "MapViewController.h"

#import "InstagramManager.h"
#import "InstagramMedia.h"
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
    BOOL _didRequestToUpdateFeed;
    NSMutableDictionary *_annotationsByMediaID;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
    bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"PHOTOMAP";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareMap];
    [self prepareRefreshButton];
}

@synthesize feed = _feed;
- (void)setFeed:(MediaFeed *)feed
{
    if (_feed)
    {
        [NSNotificationCenter.defaultCenter
            removeObserver:self
            name:kFeedDidUpdate
            object:_feed
        ];
    }
    
    _feed = feed;
    
    if (_feed)
    {
        [NSNotificationCenter.defaultCenter
            addObserverForName:kFeedDidUpdate
            object:_feed
            queue:NSOperationQueue.mainQueue
            usingBlock:^(NSNotification *notification)
            {
                NSArray *media = notification.userInfo[UpdatedObjectsKey];
                [self mapPhotos:media];
            }
        ];
         
    }
    
    [self mapPhotos:_feed.media];
}
- (void)prepareMap
{
    self.mapView.delegate = self;
}

- (void)mapPhotos:(NSArray *)mediaArray
{
    for (int i = 0; i < mediaArray.count; i++)
    {
        InstagramMedia *media = mediaArray[i];
        
        BOOL shouldAnnotate = media.hasValidLocation.boolValue && media.thumbnailURL;
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

- (void)prepareRefreshButton
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
        initWithImage:[UIImage imageNamed:@"refresh-icon"]
        style:UIBarButtonItemStylePlain
        target:self
        action:@selector(refreshFeed)
    ];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)refreshFeed
{
    if (!_didRequestToUpdateFeed)
    {
        _didRequestToUpdateFeed = YES;
        [InstagramManager.sharedManager
            getLatestForMediaFeed:self.feed
            success:^(MediaFeed *feed)
            {
                _didRequestToUpdateFeed = NO;
            }
            failure:^(NSError *error)
            {
                _didRequestToUpdateFeed = NO;
            }
        ];
    }
}


/******************************************************************************/
#pragma mark -
#pragma mark MKMapViewDelegate
/******************************************************************************/

- (MKAnnotationView *)mapView:(MKMapView *)lmapView viewForAnnotation:(id <MKAnnotation>)annotation;
{
    MapAnnotationView *annotationView = nil;
    if (annotation != self.mapView.userLocation)
    {
        static NSString *viewId = @"com.bryantjustin.photomap.annotation";
        annotationView = (MapAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:viewId];
        annotationView = [[MapAnnotationView alloc]
            initWithAnnotation:annotation
            reuseIdentifier:viewId
        ];

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
