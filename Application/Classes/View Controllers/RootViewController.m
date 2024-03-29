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
#import "SearchViewController.h"

static CGFloat const NavigationBarTitleFontSize = 15.0;

static NSString *const FeedIcon     = @"feed-icon";
static NSString *const SearchIcon   = @"search-icon";
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

@property (nonatomic,readonly) FeedViewController           *feedViewController;
@property (nonatomic,readonly) SearchViewController         *searchViewController;
@property (nonatomic,readonly) MapViewController            *mapViewController;
@property (nonatomic,readonly) ProfileViewController        *profileViewController;
@property (nonatomic,readonly) OAuthPromptViewController    *oauthPromptViewController;

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
@synthesize searchViewController        = _searchViewController;
@synthesize mapViewController           = _mapViewController;
@synthesize profileViewController       = _profileViewController;
@synthesize oauthPromptViewController   = _oauthPromptViewController;

- (FeedViewController *)feedViewController
{
    if (_feedViewController == nil)
    {
        _feedViewController = [FeedViewController new];
    }
    return _feedViewController;
}

- (SearchViewController *)searchViewController
{
    if (_searchViewController == nil)
    {
        _searchViewController = [SearchViewController new];
    }
    return _searchViewController;
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
                getSelfUserDetailsWithSuccess:^(InstagramUser *user)
                {
                    [self.profileViewController setUser:user];
                }
                failure:^(NSError *error)
                {
                    
                }
            ];
            
            [InstagramManager.sharedManager
                getSelfUserFeedWithSuccess:^(MediaFeed *feed)
                {
                    [self.mapViewController setFeed:feed];
                    [self.feedViewController setFeed:feed];
                }
                failure:^(NSError *error)
                {
                }
            ];
        }
    ];
}




/******************************************************************************/

#pragma mark - Tab Controller Methods

/******************************************************************************/

- (UITabBarController *)tabBarController
{
    if (_tabBarController == nil)
    {
        _tabBarController = [UITabBarController new];
        [_tabBarController
            setViewControllers:
            @[
                [self
                    controllerWithRootViewController:self.mapViewController
                    andBarTintColor:DarkGreyColor
                    andTintColor:UIColor.whiteColor
                ],
                [self
                    controllerWithRootViewController:self.feedViewController
                    andBarTintColor:DarkGreyColor
                    andTintColor:UIColor.whiteColor
                ],
                [self
                    controllerWithRootViewController:self.searchViewController
                    andBarTintColor:DarkGreyColor
                    andTintColor:UIColor.whiteColor
                ],
                [self
                    controllerWithRootViewController:self.profileViewController
                    andBarTintColor:UIColor.whiteColor
                    andTintColor:DarkGreyColor
                ]
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
                    tabBarItem.image = [UIImage imageNamed:MapIcon];
                    break;
                case 1:
                    tabBarItem.image = [UIImage imageNamed:FeedIcon];
                    break;
                case 2:
                    tabBarItem.image = [UIImage imageNamed:SearchIcon];
                    break;
                case 3:
                    tabBarItem.image = [UIImage imageNamed:ProfileIcon];
                    break;
            }
            
            [tabBarItem
                setTitleTextAttributes:
                @{
                    NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]
                }
                forState:UIControlStateNormal
            ];
            [tabBarItem
                setTitleTextAttributes:
                @{
                    NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]
                }
                forState:UIControlStateSelected
            ];
        }
        
        _tabBarController.tabBar.selectedImageTintColor = UIColor.whiteColor;
        _tabBarController.tabBar.translucent            = NO;
        _tabBarController.tabBar.barTintColor           = DarkGreyColor;
    }
    
    return _tabBarController;
}



/******************************************************************************/

#pragma mark - Navigation Controller Methods

/******************************************************************************/

- (UINavigationController *)controllerWithRootViewController:(UIViewController*)controller
    andBarTintColor:(UIColor *)barTintColor
    andTintColor:(UIColor *)tintColor
{
    UINavigationController *navigationController = [[UINavigationController alloc]
        initWithRootViewController:controller
    ];
    navigationController.navigationItem.hidesBackButton     = YES;
    navigationController.navigationBar.barTintColor         = barTintColor;
    navigationController.navigationBar.tintColor            = tintColor;
    navigationController.navigationBar.titleTextAttributes  =
    @{
        NSFontAttributeName             :   [UIFont
                                                fontWithName:AvenirNextBoldFont
                                                size:NavigationBarTitleFontSize
                                            ],
        NSForegroundColorAttributeName  :   tintColor
    };

    return navigationController;
}



/******************************************************************************/

#pragma mark - Status Bar Customization

/******************************************************************************/

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent; 
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
        }
    ];
}

@end
