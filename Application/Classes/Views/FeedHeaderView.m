//
//  FeedHeaderView.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-31.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "FeedHeaderView.h"

#import "InstagramMedia.h"
#import "InstagramUser.h"
#import "MediaManager.h"

@interface FeedHeaderView ()

@property (nonatomic,weak) IBOutlet UIImageView *profilePictureImageView;
@property (nonatomic,weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLapsedLabel;

@end

@implementation FeedHeaderView

@synthesize media = _media;
- (void)setMedia:(InstagramMedia *)media
{
    _media = media;
    
    [self updateProfilePictureImageView];
    [self updateUsernameLabel];
    [self updateCreateDateLabel];
}

- (void)updateProfilePictureImageView
{
    NSURL *url = self.media.user.profilePictureURL;
    if (url)
    {
        [MediaManager.sharedManager
            loadImageWithURL:url
            andCompletionBlock:^(UIImage *image)
            {
                self.profilePictureImageView.image  = image;
                [self setNeedsLayout];
            }
        ];
    }
    else
    {
        self.profilePictureImageView.image = nil;
    }
}

- (void)updateUsernameLabel
{
    [self.usernameLabel setText:self.media.user.username];
}

- (void)updateCreateDateLabel
{
    static NSCalendar *calendar = nil;
    static NSInteger const TotalComponents = 6;
    
    char *componentIdentifiers = "ywdhms";
    
    if (calendar == nil)
    {
        calendar  = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    
    NSDateComponents *components = [calendar
        components:NSYearCalendarUnit|NSWeekOfYearCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
        fromDate:self.media.createdDate
        toDate:[NSDate date]
        options:0
    ];

    NSInteger   componentsInScale[] =
    {
        components.year,
        components.weekOfYear,
        components.day,
        components.hour,
        components.minute,
        components.second
    };

    
    NSString *timeLapsed = [NSString string];
    for (NSInteger i = 0; i < TotalComponents; i++)
    {
        NSInteger componentInScale = componentsInScale[i];
        if (componentInScale > 0)
        {
            timeLapsed = [NSString stringWithFormat:@"%d%c", componentInScale, componentIdentifiers[i]];
            break;
        };
    }
    
    [self.timeLapsedLabel setText:timeLapsed];
}

@end
