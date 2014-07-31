//
//  CommentTableViewCell.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "TableViewCell.h"

@class InstagramComment;

@interface CommentTableViewCell : TableViewCell

+ (CGFloat)heightForRowWithString:(NSString *)string;

@property (nonatomic,copy) InstagramComment *comment;

@end
