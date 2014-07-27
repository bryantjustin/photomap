//
//  RootViewController.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-26.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "RootViewController.h"

#import "FeedViewController.h"
#import "OAuthPromptViewController.h"
#import "MapViewController.h"
#import "ProfileViewController.h"
#import "UserModel.h"


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
        
        for (UITabBarItem* tabBarItem in _tabBarController.tabBar.items)
        {
            tabBarItem.title = [NSString string];
        }
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
    [self prepareTabBarController];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self showOAuthPromptIfNecessary];
}

- (void)showOAuthPromptIfNecessary
{
    static BOOL _isAppearingForTheFirstTime = YES;
    
    BOOL shouldShowOAuthPrompt = !UserModel.sharedModel.hasAccess
        && _isAppearingForTheFirstTime;
    if (shouldShowOAuthPrompt)
    {
        [self showOAuthPromptWithAnimation:NO];
    }
    
    if (_isAppearingForTheFirstTime)
    {
        _isAppearingForTheFirstTime = NO;
    }
}


- (void)prepareTabBarController
{
    [self addChildViewController:self.tabBarController];
    [self.view addSubview:self.tabBarController.view];
    [self.tabBarController didMoveToParentViewController:self];
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
}

@end
