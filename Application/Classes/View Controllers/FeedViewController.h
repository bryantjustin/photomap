//
//  FeedViewController.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-26.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "ViewController.h"

@class MediaFeed;

@interface FeedViewController : ViewController
<
    UIScrollViewDelegate,
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic,strong) MediaFeed *feed;

@end
