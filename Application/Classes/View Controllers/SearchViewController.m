//
//  SearchViewController.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "SearchViewController.h"

#import "InstagramManager.h"
#import "InstagramTag.h"
#import "SearchResultsViewController.h"

static CGFloat const TagRowFontSize = 14.0;
static CGFloat const TagRowHeight   = 50.0;

static NSString *const TagCellViewIdentifier = @"TagCellViewIdentifier";

@interface SearchViewController ()

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UIButton *searchButton;
@property (nonatomic,weak) IBOutlet UITextField *searchField;

@property (nonatomic,copy) NSArray *tags;

- (IBAction)didTouchUpInsideSearchButton:(id)sender;

@end

@implementation SearchViewController
{
    BOOL _didPerformTagsQuery;
}

- (void)setTags:(NSArray *)tags
{
    _tags = tags;
    [self.tableView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
    bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"EXPLORE";
    }
    return self;
}

- (void)didTouchUpInsideSearchButton:(id)sender
{
    [self performSearch];
}



/******************************************************************************/

#pragma mark - Perform Search Method

/******************************************************************************/

- (void)performSearch
{
    [self.searchField resignFirstResponder];
    
    BOOL shouldPerformSearch = self.canSearchTags && !_didPerformTagsQuery;
    if (shouldPerformSearch)
    {
        _didPerformTagsQuery = YES;
        [InstagramManager.sharedManager
            getTagsForQuery:self.searchField.text
            success:^(NSArray *tags)
            {
                _didPerformTagsQuery = NO;
                [self setTags:tags];
            }
            failure:^(NSError *error)
            {
                _didPerformTagsQuery = NO;
            }
        ];
    }
}



/******************************************************************************/

#pragma mark - UITableViewDataSource

/******************************************************************************/

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return self.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *viewCell = [self.tableView dequeueReusableCellWithIdentifier:TagCellViewIdentifier];
    if (viewCell == nil)
    {
        viewCell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleDefault
            reuseIdentifier:TagCellViewIdentifier
        ];
        viewCell.textLabel.font = [UIFont
            fontWithName:AvenirNextMediumFont
            size:TagRowFontSize
        ];
        viewCell.textLabel.textColor = DarkGreyColor;
    }
    
    InstagramTag *tag = self.tags[indexPath.row];
    viewCell.textLabel.text = tag.name;
    return viewCell;
}



/******************************************************************************/

#pragma mark - UITableViewDelegate

/******************************************************************************/

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TagRowHeight;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView
        deselectRowAtIndexPath:indexPath
        animated:YES
    ];
    
    InstagramTag *tag = self.tags[indexPath.row];
    
    [self.navigationController
        pushViewController:[SearchResultsViewController controllerWithTag:tag]
        animated:YES
    ];
}

/******************************************************************************/

#pragma mark - UITextFieldDelegate

/******************************************************************************/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.canSearchTags)
    {
        [self performSearch];
    }
    return YES;
}

- (BOOL)canSearchTags
{
    return self.searchField.text.length > 0;
}

@end
