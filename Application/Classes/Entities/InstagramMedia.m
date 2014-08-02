//
//  InstagramMedia.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "InstagramMedia.h"
#import "InstagramComment.h"
#import "InstagramUser.h"


@implementation InstagramMedia

@dynamic createdDate;
@dynamic link;
@dynamic latitude;
@dynamic longtitude;
@dynamic type;
@dynamic thumbnailURLString;
@dynamic lowResolutionImageURLString;
@dynamic standardResolutionImageURLString;
@dynamic lowResolutionVideoURLString;
@dynamic standardResolutionVideoURLString;
@dynamic lowResolutionImageSizeString;
@dynamic lowResolutionVideoSizeString;
@dynamic standardResolutionVideoSizeString;
@dynamic standardResolutionImageSizeString;
@dynamic thumbnailSizeString;
@dynamic id;
@dynamic user;
@dynamic caption;
@dynamic comments;
@dynamic hasValidLocation;
@dynamic fromSelfFeed;



/******************************************************************************/

#pragma mark - NSURL from String Methods

/******************************************************************************/

- (NSURL *)thumbnailURL
{
    return [NSURL URLWithString:self.thumbnailURLString];
}

- (NSURL *)lowResolutionImageURL
{
    return [NSURL URLWithString:self.lowResolutionImageURLString];
}

- (NSURL *)lowResolutionVideoURL
{
    return [NSURL URLWithString:self.lowResolutionVideoURLString];
}

- (NSURL *)standardResolutionImageURL
{
    return [NSURL URLWithString:self.standardResolutionImageURLString];
}

- (NSURL *)standardResolutionVideoURL
{
    return [NSURL URLWithString:self.standardResolutionVideoURLString];
}



/******************************************************************************/

#pragma mark - CGSize from String Methods

/******************************************************************************/

- (CGSize)thumbnailSize
{
    return CGSizeFromString(self.thumbnailSizeString);
}

- (CGSize)lowResolutionImageSize
{
    return CGSizeFromString(self.lowResolutionImageSizeString);
}

- (CGSize)lowResolutionVideoSize
{
    return CGSizeFromString(self.lowResolutionVideoSizeString);
}

- (CGSize)standardResolutionImageSize
{
    return CGSizeFromString(self.standardResolutionImageSizeString);
}

- (CGSize)standardResolutionVideoSize
{
    return CGSizeFromString(self.standardResolutionVideoSizeString);
}



/******************************************************************************/

#pragma mark - Derive Location Methods

/******************************************************************************/

- (CLLocationCoordinate2D)location
{
    CLLocationCoordinate2D location = kCLLocationCoordinate2DInvalid;
    if (self.latitude && self.longtitude)
    {
        location = CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longtitude.doubleValue);
    }
    
    return location;
}

@end
