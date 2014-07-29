//
//  InstagramUser.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InstagramComment, InstagramMedia;

@interface InstagramUser : NSManagedObject

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *fullName;
@property (nonatomic, retain) NSString *profilePictureURLString;
@property (nonatomic, retain) NSString *bio;
@property (nonatomic, retain) NSString *websiteURLString;
@property (nonatomic, retain) NSNumber *mediaCount;
@property (nonatomic, retain) NSNumber *followsCount;
@property (nonatomic, retain) NSNumber *followedByCount;
@property (nonatomic, retain) NSNumber *isSelf;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *media;

@property (nonatomic, readonly) NSURL *profilePictureURL;
@property (nonatomic, readonly) NSURL *websiteURL;

@end

@interface InstagramUser (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(InstagramComment *)value;
- (void)removeCommentsObject:(InstagramComment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addMediaObject:(InstagramMedia *)value;
- (void)removeMediaObject:(InstagramMedia *)value;
- (void)addMedia:(NSSet *)values;
- (void)removeMedia:(NSSet *)values;

@end
