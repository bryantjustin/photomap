//
//  CommentTableViewCell.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "InstagramComment.h"
#import "InstagramUser.h"

static CGFloat const CommentFontSize        = 13.0;
static CGFloat const CommentUsernameMaxY    = 41.0;
static CGFloat const CommentBottomPading    = 15.0;
static CGFloat const CommentWidth           = 290.0;

@interface CommentTableViewCell ()

@property (nonatomic,weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic,weak) IBOutlet UILabel *commentLabel;

@end

@implementation CommentTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setComment:(InstagramComment *)comment
{
    self.usernameLabel.text = comment.user.username;
    
    self.commentLabel.text = comment.text;
    [self.commentLabel sizeToFit];
}

+ (CGFloat)heightForRowWithString:(NSString *)string
{
    NSAttributedString *attributedString = [[NSAttributedString alloc]
        initWithString:string
        attributes:
        @{
            NSFontAttributeName:[UIFont
                fontWithName:AvenirNextRegularFont
                size:CommentFontSize
            ]
        }
    ];
    
    UILabel *label = [UILabel new];
    [label setNumberOfLines:0];
    [label setAttributedText:attributedString];
    CGSize size = [label sizeThatFits:CGSizeMake(CommentWidth, FLT_MAX)];
    return CommentUsernameMaxY + size.height + CommentBottomPading; ;
}

@end
