//
//  ImageStoreCoordinator.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-29.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageStoreCoordinator : NSObject

/**
 *  Singleton reference to the store coordinator.
 *
 *  @return ImageStoreCoordinator instance
 */
+ (instancetype)defaultStoreCoordinator;

/**
 *  Caches an image using a given filename.
 *
 *  @param  image       NSImage image to be cached.
 *  @param  filename    NSString filename for the image.
 *
 *  @return BOOL that determines if the cache was successful.
 */
- (BOOL)cacheImage:(UIImage *)image
    withFilename:(NSString *)filename;

/**
 *  Caches the data of an image saved with a given filename.
 *  NSData should be of an image otherwise it will not be retrievable.
 *
 *  @param  data       NSData to be cached.
 *  @param  filename   NSString filename for the image.
 * 
 *  @return BOOL that determines if the cache was successful.
 */
- (BOOL)cacheImageData:(NSData *)data
    withFilename:(NSString *)filename;

/**
 *  Returns a cached image associated with a filename.
 *
 *  @param  filename   NSString filename associated with the image.
 *
 *  @return UIImage associated with the filename.
 */
- (UIImage *)imageForFilename:(NSString *)filename;

@end
