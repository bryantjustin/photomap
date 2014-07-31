//
//  ImageTableCellView.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "MediaTableViewCell.h"

#import "InstagramMedia.h"
#import "MediaManager.h"

@interface MediaTableViewCell ()



/******************************************************************************/

#pragma mark - IBOutlets

/******************************************************************************/

@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,strong) IBOutlet UIImageView *photoImageView;

@end



@implementation MediaTableViewCell

@synthesize media = _media;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.activityIndicatorView startAnimating];
}

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
                url = _media.standardResolutionImageURL;
                break;
            case InstagramMediaTypeVideo:
                url = _media.standardResolutionVideoURL;
                break;
        }
        
        self.activityIndicatorView.hidden = NO;
        
        [MediaManager.sharedManager
            loadImageWithURL:url
            andCompletionBlock:^(UIImage *image)
            {
                self.photoImageView.image           = image;
                self.activityIndicatorView.hidden   = YES;
                [self setNeedsLayout];
            }
        ];
    }
    else
    {
        self.activityIndicatorView.hidden = YES;
        self.photoImageView.image = nil;
    }
    
   
}

@end
