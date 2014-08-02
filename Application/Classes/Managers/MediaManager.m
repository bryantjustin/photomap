//
//  MediaManager.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-29.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "MediaManager.h"

#import "ImageDownloader.h"
#import "ImageStoreCoordinator.h"

@implementation MediaManager
{
    ImageDownloader *_downloader;
    ImageStoreCoordinator *_storeCoordinator;
}



/******************************************************************************/

#pragma mark - Singleton Reference

/******************************************************************************/

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken = 0ul;
    static id instance = nil;
    dispatch_once(
        &onceToken,
        ^(void)
        {
            instance = [self new];
        }
    );
    
    return instance;
}



/******************************************************************************/

#pragma mark - Init Method

/******************************************************************************/

- (instancetype)init
{
    if (self = [super init])
    {
        _downloader         = ImageDownloader.defaultDownloader;
        _storeCoordinator   = ImageStoreCoordinator.defaultStoreCoordinator;
    }
    
    return self;
}



/******************************************************************************/

#pragma mark - Load Image Method

/******************************************************************************/

- (void)loadImageWithURL:(NSURL *)url
    andCompletionBlock:(MediaManagerImageCompletionBlock)completion
{
    dispatch_async(
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul),
        ^(void)
        {
            NSString *filename = [self filenameForURL:url];
            UIImage *cachedImage = [_storeCoordinator imageForFilename:filename];
            if (cachedImage)
            {
                dispatch_async(
                    dispatch_get_main_queue(),
                    ^(void)
                    {
                        completion(cachedImage);
                    }
                );
            }
            else
            {
                [_downloader
                    downloadImageWithURL:url
                    andCompletionBlock:^(UIImage *image)
                    {
                        if (image)
                        {
                            [_storeCoordinator
                                cacheImage:[image copy]
                                withFilename:[self filenameForURL:url]
                            ];
                        }
                        
                        dispatch_async(
                            dispatch_get_main_queue(),
                            ^(void)
                            {
                                completion(image);
                            }
                        );
                    }
                ];
            }
        }
    );
}

- (NSString *)filenameForURL:(NSURL *)url
{
    // !!!
    //
    // Assumption: the last part of Instagram media URLs are unique.

    return url.absoluteString.pathComponents.lastObject;
}
@end
