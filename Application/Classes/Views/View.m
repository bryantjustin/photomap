//
//  View.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-31.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "View.h"

@implementation View

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
