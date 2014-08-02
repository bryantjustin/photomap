//
//  MediaCollectionViewCell.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "MediaCollectionViewCell.h"

#import "InstagramMedia.h"
#import "MediaManager.h"

@interface MediaCollectionViewCell ()



/******************************************************************************/

#pragma mark - IBOutlets

/******************************************************************************/

@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,strong) IBOutlet UIImageView *photoImageView;

@end



@implementation MediaCollectionViewCell

@synthesize media = _media;

- (void)setMedia:(InstagramMedia *)media
{
    _media = media;
    
    BOOL willLoadImage = _media != nil;
    if (willLoadImage)
    {
        NSURL *url = nil;
        switch (_media.type.integerValue)
        {
            case InstagramMediaTypeImage:
                url = _media.thumbnailURL;
                break;
            case InstagramMediaTypeVideo:
                url = _media.thumbnailURL;
                break;
        }
        
        [self.activityIndicatorView startAnimating];
        self.activityIndicatorView.hidden = NO;
        
        [MediaManager.sharedManager
            loadImageWithURL:url
            andCompletionBlock:^(UIImage *image)
            {
                self.photoImageView.image           = image;
                self.activityIndicatorView.hidden   = YES;
                [self.activityIndicatorView stopAnimating];
                [self setNeedsLayout];
            }
        ];
    }
    else
    {
        self.activityIndicatorView.hidden = YES;
        [self.activityIndicatorView stopAnimating];
        self.photoImageView.image = nil;
    }
}

- (void)prepareForReuse
{
    self.photoImageView.image = nil;
    [self setNeedsLayout];
}

@end
