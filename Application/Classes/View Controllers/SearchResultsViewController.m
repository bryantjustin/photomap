//
//  SearchResultsViewController.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-08-01.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "SearchResultsViewController.h"

#import "InstagramManager.h"
#import "InstagramMedia.h"
#import "InstagramTag.h"
#import "MediaCollectionViewCell.h"
#import "MediaDetailViewController.h"
#import "MediaFeed.h"

static NSString *const MediaCellViewIdentifier = @"MediaCellViewIdentifier";

@interface SearchResultsViewController ()

@property (nonatomic,weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) MediaFeed *feed;
@property (nonatomic,strong) InstagramTag *tag;

@end

@implementation SearchResultsViewController
{
    BOOL _isNibForCellLoaded;
    BOOL _didRequestToUpdateFeed;
}

@synthesize feed = _feed;
- (void)setFeed:(MediaFeed *)feed
{
    _feed = feed;
    [self.collectionView reloadData];
}

+ (instancetype)controllerWithTag:(InstagramTag *)tag
{
    return [[self alloc] initWithTag:tag];
}

- (instancetype)initWithTag:(InstagramTag *)tag
{
    if (self = [super init])
    {
        self.title = tag.name.uppercaseString;
        self.tag = tag;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareCells];
    
    [InstagramManager.sharedManager
        getMediaFeedForTag:self.tag
        success:^(MediaFeed *feed)
        {
            [self setFeed:feed];
        }
        failure:^(NSError *error)
        {
            
        }
    ];
}

- (void)prepareCells
{
    [self.collectionView
        registerClass:MediaCollectionViewCell.class
        forCellWithReuseIdentifier:MediaCellViewIdentifier
    ];
    UINib *nib = [UINib
        nibWithNibName:NSStringFromClass(MediaCollectionViewCell.class)
        bundle: nil
    ];
    [self.collectionView
        registerNib:nib
        forCellWithReuseIdentifier:MediaCellViewIdentifier
    ];
}



/******************************************************************************/

#pragma mark - UIScrollViewDelegate

/******************************************************************************/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray *indexPaths = self.collectionView.indexPathsForVisibleItems;
    if (!_didRequestToUpdateFeed)
    {
        for (NSIndexPath *indexPath in indexPaths)
        {
            if (indexPath.row == self.feed.media.count -1)
            {
                if (!_didRequestToUpdateFeed)
                {
                    _didRequestToUpdateFeed = YES;
                    [InstagramManager.sharedManager
                        getNextPageForFeed:_feed
                        success:^(MediaFeed *feed)
                        {
                            [self.collectionView reloadData];
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
    }
}


/******************************************************************************/

#pragma mark - UICollectionViewDataSource

/******************************************************************************/

- (NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return self.feed.media.count;
}



/******************************************************************************/

#pragma mark - UICollectionViewDelegate

/******************************************************************************/

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView
        deselectItemAtIndexPath:indexPath
        animated:YES
    ];
    
    [self.navigationController
        pushViewController:[MediaDetailViewController controllerWithMedia:[self mediaFromIndexPath:indexPath]]
        animated:YES
    ];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
    cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MediaCollectionViewCell *viewCell = [self.collectionView
        dequeueReusableCellWithReuseIdentifier:MediaCellViewIdentifier
        forIndexPath:indexPath
    ];
    viewCell.media = [self mediaFromIndexPath:indexPath];
    return viewCell;
}



/******************************************************************************/

#pragma mark - Data Utilities

/******************************************************************************/

- (InstagramMedia *)mediaFromIndexPath:(NSIndexPath *)indexPath
{
    return self.feed.media[indexPath.row];
}

@end
