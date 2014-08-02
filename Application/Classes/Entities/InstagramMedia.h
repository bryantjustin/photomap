//
//  InstagramMedia.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

NS_ENUM(NSInteger, InstagramMediaType)
{
    InstagramMediaTypeImage,
    InstagramMediaTypeVideo
};

@class InstagramComment, InstagramUser;

@interface InstagramMedia : NSManagedObject

@property (nonatomic, retain) NSDate *createdDate;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longtitude;
@property (nonatomic, retain) NSNumber *type;
@property (nonatomic, retain) NSString *thumbnailURLString;
@property (nonatomic, retain) NSString *lowResolutionImageURLString;
@property (nonatomic, retain) NSString *standardResolutionImageURLString;
@property (nonatomic, retain) NSString *lowResolutionVideoURLString;
@property (nonatomic, retain) NSString *standardResolutionVideoURLString;
@property (nonatomic, retain) NSString *lowResolutionImageSizeString;
@property (nonatomic, retain) NSString *lowResolutionVideoSizeString;
@property (nonatomic, retain) NSString *standardResolutionVideoSizeString;
@property (nonatomic, retain) NSString *standardResolutionImageSizeString;
@property (nonatomic, retain) NSString *thumbnailSizeString;
@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) InstagramUser *user;
@property (nonatomic, retain) InstagramComment *caption;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSNumber *hasValidLocation;
@property (nonatomic, retain) NSNumber *fromSelfFeed;


@property (nonatomic, readonly) NSURL *thumbnailURL;
@property (nonatomic, readonly) NSURL *lowResolutionImageURL;
@property (nonatomic, readonly) NSURL *lowResolutionVideoURL;
@property (nonatomic, readonly) NSURL *standardResolutionImageURL;
@property (nonatomic, readonly) NSURL *standardResolutionVideoURL;
@property (nonatomic, readonly) CGSize lowResolutionImageSize;
@property (nonatomic, readonly) CGSize lowResolutionVideoSize;
@property (nonatomic, readonly) CGSize standardResolutionVideoSize;
@property (nonatomic, readonly) CGSize standardResolutionImageSize;
@property (nonatomic, readonly) CGSize thumbnailSize;
@property (nonatomic, readonly) CLLocationCoordinate2D location;

@end

@interface InstagramMedia (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(InstagramComment *)value;
- (void)removeCommentsObject:(InstagramComment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end