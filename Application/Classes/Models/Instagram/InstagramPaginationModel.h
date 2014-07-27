//
//  InstagramPagination.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramPaginationModel : NSObject

@property (readonly) NSURL* nextURL;
@property (readonly) NSString *nextMaxId;

+ (instancetype)modelWithResponse:(NSDictionary *)response;

@end
