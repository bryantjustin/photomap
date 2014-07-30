//
//  CommentsViewController.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentTableViewCell.h"
#import "InstagramComment.h"

static CGFloat const CommentFontSize        = 12.0;
static CGFloat const CommentUsernameMaxY    = 36.0;
static CGFloat const CommentBottomPading    = 15.0;
static CGFloat const CommentWidth           = 290.0;

static NSString *const CommentViewCellIdentifier = @"CommentViewCellIdentifier";

@interface CommentsViewController ()

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,copy) NSArray *comments;

@end

@implementation CommentsViewController

+ (instancetype)controllerWithComments:(NSArray *)comments
{
    return [[self alloc] initWithComments:comments];
}

@synthesize comments = _comments;

- (instancetype)initWithComments:(NSArray *)comments
{
    if (self = [super init])
    {
        _comments = [comments
            sortedArrayUsingDescriptors:
            @[
                [NSSortDescriptor
                    sortDescriptorWithKey:@"createdDate"
                    ascending:YES
                ]
            ]
        ];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self prepareNavigationBar];
}

- (void)prepareNavigationBar
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
        initWithTitle:[NSString string]
        style:UIBarButtonItemStylePlain
        target:self.navigationController
        action:@selector(popViewControllerAnimated:)
    ];
    barButtonItem.tintColor = UIColor.whiteColor;
    self.navigationItem.backBarButtonItem = barButtonItem;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *commentViewCell = (CommentTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CommentViewCellIdentifier];
    if (commentViewCell == nil)
    {
        commentViewCell = [CommentTableViewCell new];
        commentViewCell.reuseIdentifier = CommentViewCellIdentifier;
    }
    
    [commentViewCell setComment:[self commentForIndexPath:indexPath]];
    
    return commentViewCell;
}

- (InstagramComment *)commentForIndexPath:(NSIndexPath *)indexPath
{
    return self.comments[indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InstagramComment *comment = [self commentForIndexPath:indexPath];
    CGFloat commentHeight = [self
        textViewHeightForString:comment.text
        andWidth:CommentWidth
    ];
    
    return CommentUsernameMaxY + commentHeight + CommentBottomPading;
}

- (CGFloat)textViewHeightForString:(NSString *)string
    andWidth:(CGFloat)width
{
    NSAttributedString *attributedString = [[NSAttributedString alloc]
        initWithString:string
        attributes:
        @{
            NSFontAttributeName:[UIFont
                fontWithName:AvenirFont
                size:CommentFontSize
            ]
        }
    ];
    
    UITextView *textView = [UITextView new];
    [textView setAttributedText:attributedString];
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

@end
