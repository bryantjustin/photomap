//
//  SearchResultsViewController.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-08-01.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "ViewController.h"

@class InstagramTag;

@interface SearchResultsViewController : ViewController
<
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UIScrollViewDelegate
>

+ (instancetype)controllerWithTag:(InstagramTag *)tag;

@end
