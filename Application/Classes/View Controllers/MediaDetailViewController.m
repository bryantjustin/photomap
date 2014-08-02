//
//  CommentsViewController.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "MediaDetailViewController.h"

#import "CaptionTableViewCell.h"
#import "CommentTableViewCell.h"
#import "InstagramComment.h"
#import "InstagramMedia.h"
#import "FeedHeaderView.h"
#import "LabelUtil.h"
#import "MediaTableViewCell.h"

static NSString *const CaptionViewCellIdentifier    = @"CaptionViewCellIdentifier";
static NSString *const CommentViewCellIdentifier    = @"CommentViewCellIdentifier";
static NSString *const MediaCellViewIdentifier      = @"MediaCellViewIdentifier";

static NSInteger const MediaIndex       = 0;
static NSInteger const CaptionIndex     = 1;
static NSInteger const MediaOffset      = 1;
static NSInteger const CaptionOffset    = 1;

static CGFloat const SectionHeaderHeight    = 50;
static CGFloat const SectionFooterHeight    = 0.01;
static CGFloat const RowMediaHeight         = 320.0;

static CGFloat const CommentFontSize        = 13.0;
static CGFloat const CommentUsernameMaxY    = 41.0;
static CGFloat const CommentBottomPadding   = 15.0;
static CGFloat const CommentWidth           = 290.0;

static CGFloat const CaptionFontSize        = 13.0;
static CGFloat const CaptionPadding         = 15 * 2; // Top and bottom
static CGFloat const CaptionWidth           = 290.0;

@interface MediaDetailViewController ()

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,copy) NSArray *comments;
@property (nonatomic,copy) InstagramMedia *media;

@end


@implementation MediaDetailViewController

+ (instancetype)controllerWithMedia:(InstagramMedia *)media
{
    return [[self alloc] initWithMedia:media];
}

@synthesize comments = _comments;
@synthesize media = _media;

- (instancetype)initWithMedia:(InstagramMedia *)media
{
    if (self = [super init])
    {
        _media = media;
        _comments = [media.comments
            sortedArrayUsingDescriptors:
            @[
                [NSSortDescriptor
                    sortDescriptorWithKey:@"createdDate"
                    ascending:NO
                ]
            ]
        ];
        
        self.title = _media.type.integerValue == InstagramMediaTypeVideo ? @"VIDEO" : @"PHOTO";
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



/******************************************************************************/

#pragma mark - UITableViewDataSource Methods

/******************************************************************************/

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count + MediaOffset + CaptionOffset;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *viewCell = nil;
    if (indexPath.row == MediaIndex)
    {
        viewCell = [self mediaTableViewCell];
    }
    else if(indexPath.row == CaptionIndex)
    {
        viewCell = [self captionTableViewCell];
    }
    else
    {
        viewCell = [self commentTableViewCellForIndexPath:indexPath];
    }
    
    return viewCell;
}

- (MediaTableViewCell *)mediaTableViewCell
{
    MediaTableViewCell *mediaViewCell = (MediaTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:MediaCellViewIdentifier];
    if (mediaViewCell == nil)
    {
        mediaViewCell = [MediaTableViewCell new];
    }
    [mediaViewCell setMedia:self.media];
    return mediaViewCell;
}

- (CaptionTableViewCell *)captionTableViewCell;
{
    CaptionTableViewCell *captionViewCell = (CaptionTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CaptionViewCellIdentifier];
    if (captionViewCell == nil)
    {
        captionViewCell = [CaptionTableViewCell new];
    }
    [captionViewCell setCaption:self.media.caption];
    return captionViewCell;
}

- (CommentTableViewCell *)commentTableViewCellForIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *commentViewCell = (CommentTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CommentViewCellIdentifier];
    if (commentViewCell == nil)
    {
        commentViewCell = [CommentTableViewCell new];
    }
    [commentViewCell setComment:[self commentForIndexPath:indexPath]];
    return commentViewCell;
}

- (InstagramComment *)commentForIndexPath:(NSIndexPath *)indexPath
{
    return self.comments[indexPath.row - MediaOffset - CaptionOffset];
}



/******************************************************************************/

#pragma mark - UITableViewDelegate Methods

/******************************************************************************/

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section
{
    return SectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForFooterInSection:(NSInteger)section
{
    return SectionFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FeedHeaderView *headerView = [FeedHeaderView new];
    [headerView setMedia:self.media];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView
    viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;

    if (indexPath.row == MediaIndex)
    {
        height = RowMediaHeight;
    }
    else if (indexPath.row == CaptionIndex)
    {
        height = self.media.caption.text ? [LabelUtil
            heightForRowWithString:self.media.caption.text
            font:[UIFont
                fontWithName:AvenirNextRegularFont
                size:CaptionFontSize
            ]
            width:CaptionWidth
            padding:CaptionPadding
        ] : 0;
    }
    else
    {
        height = [LabelUtil
            heightForRowWithString:[self commentForIndexPath:indexPath].text
            font:[UIFont
                fontWithName:AvenirNextRegularFont
                size:CommentFontSize
            ]
            width:CommentWidth
            padding:CommentUsernameMaxY + CommentBottomPadding
        ];
    }
    
    return height;
}

@end
