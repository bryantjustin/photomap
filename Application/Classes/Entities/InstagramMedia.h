//
//  InstagramMedia.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InstagramComment, InstagramUser;

@interface InstagramMedia : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longtitude;
@property (nonatomic, retain) NSNumber * isVideo;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * lowResolutionImageURL;
@property (nonatomic, retain) NSString * standardResolutionImageURL;
@property (nonatomic, retain) NSString * lowResolutionVideoURL;
@property (nonatomic, retain) NSString * standardResolutionVideoURL;
@property (nonatomic, retain) NSString * lowResolutionImageRectSize;
@property (nonatomic, retain) NSString * lowResolutionVideoRectSize;
@property (nonatomic, retain) NSString * standardResolutionVideoRectSize;
@property (nonatomic, retain) NSString * standardResolutionImageRectSize;
@property (nonatomic, retain) NSString * thumbnailURLRectSize;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) InstagramUser *user;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) InstagramComment *caption;
@end

@interface InstagramMedia (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(InstagramComment *)value;
- (void)removeCommentsObject:(InstagramComment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
