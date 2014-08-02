//
//  FeedViewController.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-26.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "FeedViewController.h"

#import "MediaDetailViewController.h"
#import "FeedHeaderView.h"
#import "InstagramComment.h"
#import "InstagramMedia.h"
#import "InstagramManager.h"
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
static CGFloat const RowCaptionHeight   = 75;
static CGFloat const RowCommentHeight   = 30;
static CGFloat const RowSpacerHeight    = 75;
static CGFloat const CommentRowFontSize = 12.;

static NSString *const CaptionCellViewIdentifier        = @"CaptionCellViewIdentifier";
static NSString *const CommentButtonCellViewIdentifier  = @"CommentButtonCellViewIdentifier";
static NSString *const MediaCellViewIdentifier          = @"MediaCellViewIdentifier";
static NSString *const SpacerCellViewIdentifier         = @"SpacerCellViewIdentifier";


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
    
    // Do any additional setup after loading the view from its nib.
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
                reuseIdentifier:SpacerCellViewIdentifier
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
    MediaTableViewCell *mediaViewCell = (MediaTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:MediaCellViewIdentifier];
    if (mediaViewCell == nil)
    {
        mediaViewCell = [MediaTableViewCell new];
        mediaViewCell.reuseIdentifier = MediaCellViewIdentifier;
    }

    [mediaViewCell setMedia:media];

    return mediaViewCell;
}

- (UITableViewCell *)commentTableViewCellForMedia:(InstagramMedia *)media
{
    UITableViewCell *viewCell = [self.tableView dequeueReusableCellWithIdentifier:CommentButtonCellViewIdentifier];
    if (viewCell == nil)
    {
        viewCell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleDefault
            reuseIdentifier:CommentButtonCellViewIdentifier
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

- (UITableViewCell *)captionTableViewCellForMedia:(InstagramMedia *)media
{
    UITableViewCell *viewCell = [self.tableView dequeueReusableCellWithIdentifier:CaptionCellViewIdentifier];
    if (viewCell == nil)
    {
        viewCell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleDefault
            reuseIdentifier:CaptionCellViewIdentifier
        ];
        viewCell.textLabel.font = [UIFont
            fontWithName:AvenirRomanFont
            size:CommentRowFontSize
        ];
        viewCell.textLabel.textColor = DarkGreyColor;
        viewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    viewCell.textLabel.numberOfLines    = 3;
    viewCell.textLabel.text             = media.caption.text;
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
    if ([cell.reuseIdentifier isEqualToString:MediaCellViewIdentifier])
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
    switch (indexPath.row)
    {
        case RowTypeMedia:
            heightForRow = RowMediaHeight;
            break;
        
        case RowTypeCaption:
            heightForRow = RowCaptionHeight;
            break;
            
        case RowTypeComments:
            heightForRow = RowCommentHeight;
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
