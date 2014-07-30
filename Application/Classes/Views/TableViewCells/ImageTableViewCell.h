//
//  ImageTableCellView.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "TableViewCell.h"

@interface ImageTableViewCell : TableViewCell



/******************************************************************************/

#pragma mark - IBOutlets

/******************************************************************************/

@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,strong) IBOutlet UIImageView *photoImageView;



/******************************************************************************/

#pragma mark - Properties

/******************************************************************************/

@property (nonatomic, strong) NSURL *URL;

@end
