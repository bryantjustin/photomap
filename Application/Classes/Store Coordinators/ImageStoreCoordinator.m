//
//  ImageStoreCoordinator.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-29.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "ImageStoreCoordinator.h"

static NSString *const ImagesDirectory = @"images";

@implementation ImageStoreCoordinator



/******************************************************************************/

#pragma mark - Singleton reference

/******************************************************************************/

+ (instancetype)defaultStoreCoordinator
{
    static dispatch_once_t predicate = 0ul;
    static id instance = nil;
    
    dispatch_once(
        &predicate,
        ^(void)
        {
            instance = [self new];
            [instance createImagesDirectoryIfNecessary];
        }
    );
    
    return instance;
}



/******************************************************************************/

#pragma mark - Utility methods

/******************************************************************************/

- (void)createImagesDirectoryIfNecessary
{
    NSError * error = nil;
    [NSFileManager.defaultManager
        createDirectoryAtPath:self.imagesPath
        withIntermediateDirectories:YES
        attributes:nil
        error:&error
    ];
    
    if (error)
    {
        NSLog( @"ERROR: Failed to create contact images directory – %@", error.localizedDescription );
    }
}

- (NSString *)baseFilePath
{
    static NSString *_baseFilePath = nil;
    if (_baseFilePath == nil)
    {
        _baseFilePath = NSSearchPathForDirectoriesInDomains(
            NSCachesDirectory,
            NSUserDomainMask,
            YES
        ).lastObject;
    }
    
    return _baseFilePath;
}

- (NSString *)imagesPath
{
    static NSString *_imagesPath = nil;
    if (_imagesPath == nil)
    {
        _imagesPath = [NSString stringWithFormat: @"%@/%@",
            self.baseFilePath,
            ImagesDirectory
        ];
    }
    
    return _imagesPath;
}

- (NSString *)filePathWithFilename:(NSString *)filename
{
    return [NSString stringWithFormat: @"%@/%@",
        self.imagesPath,
        filename
    ];
}



/******************************************************************************/

#pragma mark - Public methods

/******************************************************************************/

- (BOOL)cacheImage:(UIImage *)image
    withFilename:(NSString *)filename
{
    return [self
        cacheImageData:UIImagePNGRepresentation(image)
        withFilename:filename
    ];
}

- (BOOL)cacheImageData:(NSData *)data
    withFilename:(NSString *)filename
{
    return [NSKeyedArchiver
        archiveRootObject:data
        toFile:[self filePathWithFilename:filename]
    ];
}

- (UIImage *)imageForFilename:(NSString *)filename
{
    UIImage *image = nil;
    
    NSString *file = [self filePathWithFilename:filename];
    if ([NSFileManager.defaultManager fileExistsAtPath:file])
    {
        NSData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
        image = [UIImage imageWithData:data];
    }
    
    return image;
}

@end
