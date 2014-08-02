//
//  FeedViewController.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-26.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "FeedViewController.h"

#import "CaptionTableViewCell.h"
#import "FeedHeaderView.h"
#import "InstagramComment.h"
#import "InstagramMedia.h"
#import "InstagramManager.h"
#import "LabelUtil.h"
#import "MediaDetailViewController.h"
#import "MediaFeed.h"
#import "MediaTableViewCell.h"

NS_ENUM(NSInteger, RowType)
{
    RowTypeMedia,
    RowTypeCaption,
    RowTypeComments,
    RowTypeSpacer
};

static NSInteger const RowsPerSection = 4;

static CGFloat const SectionHeight      = 50;
static CGFloat const RowMediaHeight     = 320.0;
static CGFloat const RowCommentHeight   = 30;
static CGFloat const RowSpacerHeight    = 100;
static CGFloat const CommentRowFontSize = 12.;

static NSString *const CaptionViewCellIdentifier        = @"CaptionViewCellIdentifier";
static NSString *const CommentButtonViewCellIdentifier  = @"CommentButtonViewCellIdentifier";
static NSString *const MediaViewCellIdentifier          = @"MediaViewCellIdentifier";
static NSString *const SpacerViewCellIdentifier         = @"SpacerViewCellIdentifier";

static CGFloat const CaptionFontSize    = 13.0;
static CGFloat const CaptionPadding     = 15 * 2; // Top and bottom
static CGFloat const CaptionWidth       = 290.0;

@interface FeedViewController ()

@property (nonatomic,weak) IBOutlet UITableView *tableView;

@end

@implementation FeedViewController
{
    BOOL _didRequestToUpdateFeed;
}


/******************************************************************************/

#pragma mark - Properties

/******************************************************************************/

@synthesize feed = _feed;

- (void)setFeed:(MediaFeed *)feed
{
    if (_feed)
    {
        [NSNotificationCenter.defaultCenter
            removeObserver:self
            name:kFeedDidUpdate
            object:_feed
        ];
    }
    
    _feed = feed;
    
    if (_feed)
    {
        [NSNotificationCenter.defaultCenter
            addObserverForName:kFeedDidUpdate
            object:_feed
            queue:NSOperationQueue.mainQueue
            usingBlock:^(NSNotification *notification)
            {
                [self.tableView reloadData];
            }
        ];
         
    }
    [self.tableView reloadData];
}

- (BOOL)hasSections
{
    return _feed && _feed.media.count > 0;
}


/******************************************************************************/

#pragma mark - Inherited Methods

/******************************************************************************/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"FEED"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareRefreshButton];
}

- (void)prepareRefreshButton
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
        initWithImage:[UIImage imageNamed:@"refresh-icon"]
        style:UIBarButtonItemStylePlain
        target:self
        action:@selector(refreshFeed)
    ];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)refreshFeed
{
    if (!_didRequestToUpdateFeed)
    {
        _didRequestToUpdateFeed = YES;
        [InstagramManager.sharedManager
            getLatestForMediaFeed:self.feed
            success:^(MediaFeed *feed)
            {
                _didRequestToUpdateFeed = NO;
                [self.tableView reloadData];
            }
            failure:^(NSError *error)
            {
                _didRequestToUpdateFeed = NO;
            }
        ];
    }
}

/******************************************************************************/

#pragma mark - UITableViewDataSource Methods

/******************************************************************************/

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return self.hasSections ? RowsPerSection : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InstagramMedia *media = [self mediaFromIndexPath:indexPath];
    UITableViewCell *viewCell = nil;

    switch (indexPath.row)
    {
        case RowTypeMedia:
            viewCell = [self mediaTableViewCellForMedia:media];
            break;
        
        case RowTypeCaption:
            viewCell = [self captionTableViewCellForMedia:media];
            break;
            
        case RowTypeComments:
            viewCell = [self commentTableViewCellForMedia:media];
            break;
            
        case RowTypeSpacer:
            viewCell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SpacerViewCellIdentifier
            ];
            viewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
    }
    
    return viewCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = 0;
    if (self.hasSections)
    {
        numberOfSections = self.feed.media.count;
    }
    return numberOfSections;
}

- (UITableViewCell *)mediaTableViewCellForMedia:(InstagramMedia *)media
{
    MediaTableViewCell *mediaViewCell = (MediaTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:MediaViewCellIdentifier];
    if (mediaViewCell == nil)
    {
        mediaViewCell = [MediaTableViewCell new];
    }
    [mediaViewCell setMedia:media];
    return mediaViewCell;
}

- (UITableViewCell *)captionTableViewCellForMedia:(InstagramMedia *)media
{
    CaptionTableViewCell *captionViewCell = (CaptionTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CaptionViewCellIdentifier];
    if (captionViewCell == nil)
    {
        captionViewCell = [CaptionTableViewCell new];
    }
    [captionViewCell setCaption:media.caption];
    return captionViewCell;
}

- (UITableViewCell *)commentTableViewCellForMedia:(InstagramMedia *)media
{
    UITableViewCell *viewCell = [self.tableView dequeueReusableCellWithIdentifier:CommentButtonViewCellIdentifier];
    if (viewCell == nil)
    {
        viewCell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleDefault
            reuseIdentifier:CommentButtonViewCellIdentifier
        ];
        viewCell.textLabel.font = [UIFont
            fontWithName:AvenirNextDemiBoldFont
            size:CommentRowFontSize
        ];
        viewCell.textLabel.textColor = DarkGreyColor;
        viewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger commentCount = media.comments.count;
    if (commentCount > 0)
    {
        viewCell.textLabel.text = [NSString stringWithFormat:@"Comments (%lu)", (long)commentCount];
        viewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        viewCell.textLabel.text = @"No comments";
        viewCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return viewCell;
}



/******************************************************************************/

#pragma mark - UITableViewDelegate Methods

/******************************************************************************/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FeedHeaderView *headerView = [FeedHeaderView new];
    [headerView setMedia:[self mediaFromSection:section]];
    return headerView;
}

- (void)tableView:(UITableView *)tableView
    willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= self.feed.media.count -1)
    {
        if (!_didRequestToUpdateFeed)
        {
            _didRequestToUpdateFeed = YES;
            [InstagramManager.sharedManager
                getNextPageForFeed:_feed
                success:^(MediaFeed *feed)
                {
                    _didRequestToUpdateFeed = NO;
                }
                failure:^(NSError *error)
                {
                    _didRequestToUpdateFeed = NO;
                }
            ];
        }
    }
}

- (void)tableView:(UITableView *)tableView
    didEndDisplayingCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell.reuseIdentifier isEqualToString:MediaViewCellIdentifier])
    {
        MediaTableViewCell *mediaTableViewCell = (MediaTableViewCell *)cell;
        [mediaTableViewCell setMedia:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section
{
    return SectionHeight;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 0.;
    InstagramMedia *media = [self mediaFromIndexPath:indexPath];
    switch (indexPath.row)
    {
        case RowTypeMedia:
            heightForRow = RowMediaHeight;
            break;
        
        case RowTypeCaption:
            heightForRow = [LabelUtil
                heightForRowWithString:media.caption.text
                font:[UIFont
                    fontWithName:AvenirNextRegularFont
                    size:CaptionFontSize
                ]
                width:CaptionWidth
                padding:CaptionPadding
            ];
            break;
            
        case RowTypeComments:
            heightForRow = media.comments.count > 0 ? RowCommentHeight : 0;
            break;
            
        case RowTypeSpacer:
            heightForRow = RowSpacerHeight;
            break;
    }

    return heightForRow;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == RowTypeSpacer)
    {
        return;
    }
    
    [tableView
        deselectRowAtIndexPath:indexPath
        animated:YES
    ];
    
    InstagramMedia *media = [self mediaFromIndexPath:indexPath];
    BOOL hasComments = media && media.comments.count > 0;
    if (hasComments)
    {
        [self.navigationController
            pushViewController:[MediaDetailViewController controllerWithMedia:media]
            animated:YES
        ];
    }
}

/******************************************************************************/

#pragma mark - Data Utilities

/******************************************************************************/

- (InstagramMedia *)mediaFromIndexPath:(NSIndexPath *)indexPath
{
    return [self mediaFromSection:indexPath.section];
}

- (InstagramMedia *)mediaFromSection:(NSInteger)section
{
    return self.feed.media[section];
}



@end
