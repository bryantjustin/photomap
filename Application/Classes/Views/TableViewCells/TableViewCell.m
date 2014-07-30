//
//  TableViewCell.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-30.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

@synthesize reuseIdentifier = _reuseIdentifier;

- (id)init
{
    self =  [NSBundle.mainBundle
        loadNibNamed:self.class.description
        owner:self
        options:nil
    ].firstObject;
    
    return self;
}

@end
