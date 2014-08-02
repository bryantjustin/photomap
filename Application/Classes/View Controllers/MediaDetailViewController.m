//
//  CommentsViewController.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "MediaDetailViewController.h"

#import "CommentTableViewCell.h"
#import "InstagramComment.h"
#import "InstagramMedia.h"
#import "FeedHeaderView.h"
#import "MediaTableViewCell.h"

static NSString *const MediaCellViewIdentifier      = @"MediaCellViewIdentifier";
static NSString *const CommentViewCellIdentifier    = @"CommentViewCellIdentifier";

static NSInteger const MediaIndex   = 0;
static NSInteger const MediaOffset  = 1;

static CGFloat const SectionHeaderHeight    = 50;
static CGFloat const SectionFooterHeight    = 0.01;
static CGFloat const RowMediaHeight         = 320.0;

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
    return self.comments.count + MediaOffset;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *viewCell = nil;
    if (indexPath.row == MediaIndex)
    {
        viewCell = [self mediaTableViewCell];
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
        [mediaViewCell setMedia:self.media];
    }
    return mediaViewCell;
}

- (CommentTableViewCell *)commentTableViewCellForIndexPath:(NSIndexPath *)indexPath
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
    return self.comments[indexPath.row - MediaOffset];
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
    else
    {
        height = [CommentTableViewCell heightForRowWithString:[self commentForIndexPath:indexPath].text];
    }
    
    return height;
}

@end
