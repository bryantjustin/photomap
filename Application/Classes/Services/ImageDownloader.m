//
//  ImageDownloader.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-29.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "ImageDownloader.h"

@implementation ImageDownloader

/******************************************************************************/

#pragma mark - Singleton reference

/******************************************************************************/

+ (instancetype)defaultDownloader
{
    static dispatch_once_t predicate = 0ul;
    static id instance = nil;
    
    dispatch_once(
        &predicate,
        ^(void)
        {
            instance = [self new];
        }
    );
    
    return instance;
}



/******************************************************************************/

#pragma mark - Download Methods

/******************************************************************************/

- (void)downloadImageWithURL:(NSURL *)url
    andCompletionBlock:(ImageDownloaderImageBlock)completion
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection
        sendAsynchronousRequest:request
        queue:NSOperationQueue.mainQueue
        completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
        {
            UIImage *image = nil;
            if (error == nil)
            {
                image = [UIImage imageWithData:data];
            }
            
            completion(image);
        }
    ];
}

@end
