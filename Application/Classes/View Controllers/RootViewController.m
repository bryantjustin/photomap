//
//  RootViewController.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-26.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "RootViewController.h"

#import "FeedViewController.h"
#import "InstagramManager.h"
#import "InstagramUser.h"
#import "MapViewController.h"
#import "OAuthPromptViewController.h"
#import "ProfileViewController.h"

static NSString *const MapIcon      = @"map-icon";
static NSString *const ProfileIcon  = @"profile-icon";

#define IconInsets UIEdgeInsetsMake(5, 0, -5, 0);


/******************************************************************************/

#pragma mark - Class Extension

/******************************************************************************/

@interface RootViewController ()

/**
 *  Tab bar controller for switching between sections of the application.
 */
@property (nonatomic,readonly) UITabBarController *tabBarController;

@property (nonatomic,readonly) FeedViewController *feedViewController;
@property (nonatomic,readonly) MapViewController *mapViewController;
@property (nonatomic,readonly) ProfileViewController *profileViewController;
@property (nonatomic,readonly) OAuthPromptViewController *oauthPromptViewController;

@end



/******************************************************************************/

#pragma mark - Class Implementation

/******************************************************************************/

@implementation RootViewController



/******************************************************************************/

#pragma mark - Properties

/******************************************************************************/

@synthesize tabBarController            = _tabBarController;
@synthesize feedViewController          = _feedViewController;
@synthesize mapViewController           = _mapViewController;
@synthesize profileViewController       = _profileViewController;
@synthesize oauthPromptViewController   = _oauthPromptViewController;

- (UITabBarController *)tabBarController
{
    if (_tabBarController == nil)
    {
        _tabBarController = [UITabBarController new];
        [_tabBarController
            setViewControllers:
            @[
                [self controllerWithRootController:self.feedViewController],
                [self controllerWithRootController:self.mapViewController],
                self.profileViewController
            ]
        ];
        
        for (int i = 0; i < _tabBarController.tabBar.items.count; i++)
        {
            UITabBarItem *tabBarItem    = _tabBarController.tabBar.items[i];
            tabBarItem.title            = [NSString string];
            tabBarItem.imageInsets      = IconInsets;
            switch (i)
            {
                case 0:
                case 1:
                    tabBarItem.image = [UIImage imageNamed:MapIcon];
                    break;
                case 2:
                    tabBarItem.image = [UIImage imageNamed:ProfileIcon];
                    break;
            }
            
        }
        
        _tabBarController.tabBar.translucent    = NO;
        _tabBarController.tabBar.barTintColor   = DarkGreyColor;
    }
    
    return _tabBarController;
}

- (FeedViewController *)feedViewController
{
    if (_feedViewController == nil)
    {
        _feedViewController = [FeedViewController new];
    }
    return _feedViewController;
}

- (MapViewController *)mapViewController
{
    if (_mapViewController == nil)
    {
        _mapViewController = [MapViewController new];
    }
    return _mapViewController;
}

- (ProfileViewController *)profileViewController
{
    if (_profileViewController == nil)
    {
        _profileViewController = [ProfileViewController new];
    }
    return _profileViewController;
}

- (OAuthPromptViewController *)oauthPromptViewController
{
    if (_oauthPromptViewController == nil)
    {
        _oauthPromptViewController = [OAuthPromptViewController new];
    }
    return _oauthPromptViewController;
}



/******************************************************************************/

#pragma mark - Inherited Methods

/******************************************************************************/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self startFetchingInitialData];
}

- (void)prepareTabBarController
{
    [self addChildViewController:self.tabBarController];
    [self.view addSubview:self.tabBarController.view];
    [self.tabBarController didMoveToParentViewController:self];
}

- (void)startFetchingInitialData
{
    if (InstagramManager.sharedManager.requiresAccess)
    {
        [self showOAuthPromptWithAnimation:NO];
    }
    else
    {
        [self continueDataInitialization];
    }
}

- (void)continueDataInitialization
{
    [self prepareTabBarController];
    
    [InstagramManager.sharedManager
        initializeManagerWithCompletion:^(NSError *error)
        {
            [InstagramManager.sharedManager
                getSelfUserFeedWithSuccess:^(NSArray *media, InstagramPagination *pagination)
                {
                
                }
                failure:^(NSError *error)
                {
                }
            ];
        }
    ];
}



/******************************************************************************/

#pragma mark - Navigation Controller Methods

/******************************************************************************/

- (UINavigationController *)controllerWithRootController:(UIViewController *)controller
{
    UINavigationController *navigationController = [[UINavigationController alloc]
        initWithRootViewController:controller
    ];
    
    return navigationController;
}



/******************************************************************************/

#pragma mark - Show Login

/******************************************************************************/

- (void)showOAuthPromptWithAnimation:(BOOL)animation
{
    [self
        presentViewController:self.oauthPromptViewController
        animated:animation
        completion:nil
    ];
    
    [NSNotificationCenter.defaultCenter
        addObserverForName:kDidSuccessfullyAuthenticate
        object:nil
        queue:nil
        usingBlock:^(NSNotification *notification)
        {
            [self.oauthPromptViewController
                dismissViewControllerAnimated:YES
                completion:nil
            ];
            
            [NSNotificationCenter.defaultCenter
                removeObserver:self
                name:kDidSuccessfullyAuthenticate
                object:nil
            ];
            
            [self continueDataInitialization];
        }
    ];
}

@end
