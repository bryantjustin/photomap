//
//  MediaManager.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-29.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MediaManagerImageCompletionBlock)    (UIImage *image);

@interface MediaManager : NSObject

+ (instancetype)sharedManager;

- (void)loadImageWithURL:(NSURL *)url
    andCompletionBlock:(MediaManagerImageCompletionBlock)completion;

@end
