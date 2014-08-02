//
//  CommentsViewController.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "ViewController.h"

@class InstagramMedia;

@interface MediaDetailViewController : ViewController
<
    UITableViewDataSource,
    UITableViewDelegate
>

+ (instancetype)controllerWithMedia:(InstagramMedia *)media;

@end
