//
//  SearchViewController.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "SearchViewController.h"
#import "InstagramManager.h"

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTouchUpInsideSearchButton:(id)sender
{
    if (!_didPerformTagsQuery)
    {
        _didPerformTagsQuery = YES;
        [InstagramManager.sharedManager
            getTagsForQuery:self.searchField.text
            success:^(NSArray *tags) {
                [self setTags:tags];
            }
            failure:^(NSError *error)
            {
                
            }
        ];
    }
}

@end
