//
//  ProfileViewController.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-26.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "ProfileViewController.h"

#import "InstagramUser.h"
#import "MediaManager.h"

@interface ProfileViewController ()

@property (nonatomic,weak) IBOutlet UIImageView *profilePictureImageView;
@property (nonatomic,weak) IBOutlet UILabel     *bioLabel;
@property (nonatomic,weak) IBOutlet UIButton    *websiteURLButton;

@end

@implementation ProfileViewController

@synthesize user = _user;

- (void)setUser:(InstagramUser *)user
{
    _user = user;
    
    [self setTitle:user.username.uppercaseString];
    
    [self updateBio];
    [self updateProfilePicture];
    [self updateTabBarTitle];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateBio];
    [self updateProfilePicture];
    [self updateTabBarTitle];
}

- (void)updateProfilePicture
{
    NSURL *url = self.user.profilePictureURL;
    if (url)
    {
        [MediaManager.sharedManager
            loadImageWithURL:url
            andCompletionBlock:^(UIImage *image)
            {
                self.profilePictureImageView.image  = image;
                [self.view setNeedsLayout];
            }
        ];
    }
    else
    {
        self.profilePictureImageView.image = nil;
    }
}

- (void)updateBio
{
    [self.bioLabel setText:self.user.bio];
}

- (void)updateTabBarTitle
{
    self.tabBarController.tabBarItem.title = @"";
}
@end
