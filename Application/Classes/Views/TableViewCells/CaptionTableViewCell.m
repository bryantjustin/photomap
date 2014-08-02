//
//  CaptionTableViewCell.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-08-02.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "CaptionTableViewCell.h"
#import "InstagramComment.h"

@interface CaptionTableViewCell ()

@property (nonatomic,weak) IBOutlet UILabel *captionLabel;
@end

@implementation CaptionTableViewCell

@synthesize caption = _caption;
- (void)setCaption:(InstagramComment *)caption
{
    _caption = caption;
    self.captionLabel.text = _caption.text;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
