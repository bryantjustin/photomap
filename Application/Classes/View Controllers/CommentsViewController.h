//
//  CommentsViewController.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsViewController : UIViewController
<
    UITableViewDataSource,
    UITableViewDelegate
>
+ (instancetype)controllerWithComments:(NSArray *)comments;

@end
