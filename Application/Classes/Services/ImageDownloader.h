//
//  ImageDownloader.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-29.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ImageDownloaderImageBlock)   (UIImage *image);

@interface ImageDownloader : NSObject

+ (instancetype)defaultDownloader;

- (void)downloadImageWithURL:(NSURL *)url
    andCompletionBlock:(ImageDownloaderImageBlock)completion;

@end
