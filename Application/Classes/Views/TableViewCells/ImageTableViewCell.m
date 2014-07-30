//
//  ImageTableCellView.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "MediaManager.h"

@interface ImageTableViewCell ()


@end

@implementation ImageTableViewCell

@synthesize URL = _URL;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.activityIndicatorView startAnimating];
}

- (void)setURL:(NSURL *)URL
{
    _URL = URL;
    
    BOOL willLoadImage = _URL != nil;
    if (willLoadImage)
    {
        self.activityIndicatorView.hidden = NO;
        
        [MediaManager.sharedManager
            loadImageWithURL:_URL
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
