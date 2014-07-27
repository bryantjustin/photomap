//
//  OAuthPromptViewController.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-26.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "OAuthPromptViewController.h"
#import "InstagramService.h"

@interface OAuthPromptViewController ()

@end

@implementation OAuthPromptViewController

- (IBAction)didTouchUpInsideSignInButton:(id)sender
{
    [InstagramService.sharedService login];
    [self observeSuccessfulAuthentication];
}

- (void)observeSuccessfulAuthentication
{
    [NSNotificationCenter.defaultCenter
        addObserverForName:kDidSuccessfullyAuthenticate
        object:InstagramService.sharedService
        queue:nil
        usingBlock:^(NSNotification *notification)
        {
            [self
                dismissViewControllerAnimated:YES
                completion:nil
            ];
            
            [NSNotificationCenter.defaultCenter
                removeObserver:self
                name:kDidSuccessfullyAuthenticate
                object:InstagramService.sharedService
            ];
        }
    ];
}

@end
