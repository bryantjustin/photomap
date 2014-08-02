//
//  SearchResultsViewController.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-08-01.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "SearchResultsViewController.h"

@interface SearchResultsViewController ()

@property (nonatomic,weak) IBOutlet UICollectionView *collectionView;
@end

@implementation SearchResultsViewController

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


@end
