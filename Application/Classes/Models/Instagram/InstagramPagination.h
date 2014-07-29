//
//  InstagramPagination.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramPagination : NSObject

@property (nonatomic,strong) NSURL* nextURL;
@property (nonatomic,copy) NSString *nextMaxId;

@end
