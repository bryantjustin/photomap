//
//  ImageTableCellView.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "TableViewCell.h"

@class InstagramMedia;

@interface MediaTableViewCell : TableViewCell



/******************************************************************************/

#pragma mark - Properties

/******************************************************************************/

@property (nonatomic, strong) InstagramMedia *media;

@end
