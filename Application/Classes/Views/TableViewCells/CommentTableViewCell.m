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

@end
