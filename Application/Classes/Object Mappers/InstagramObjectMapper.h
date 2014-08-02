//
//  InstagramParser.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-28.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InstagramComment;
@class InstagramUser;
@class InstagramPagination;
@class InstagramMedia;
@class InstagramTag;

extern NSString *const IDKey;
extern NSString *const UsernameKey;
extern NSString *const FullNameKey;
extern NSString *const ProfilePictureURLKey;
extern NSString *const BioKey;
extern NSString *const WebsiteKey;

extern NSString *const CountsKey;
extern NSString *const MediaCountsKey;
extern NSString *const FollowsCountsKey;
extern NSString *const FollowedByCountsKey;

extern NSString *const NextURLKey;
extern NSString *const NextMaxIDKey;

extern NSString *const CreatorKey;
extern NSString *const TextKey;
extern NSString *const CreatedTimeKey;

extern NSString *const CaptionKey;
extern NSString *const CommentsKey;
extern NSString *const DataKey;
extern NSString *const LocationKey;
extern NSString *const LatitudeKey;
extern NSString *const LongitudeKey;
extern NSString *const ImagesKey;
extern NSString *const VideosKey;
extern NSString *const ThumbnailKey;
extern NSString *const LowResolutionKey;
extern NSString *const StandardResolutionKey;
extern NSString *const URLKey;
extern NSString *const HeightKey;
extern NSString *const WidthKey;

extern NSString *const TypeKey;
extern NSString *const ImageKey;
extern NSString *const VideoKey;

typedef InstagramUser*      (^InstagramObjectMapperUserEntityRequestHandler)        (NSDictionary *userResponse);
typedef InstagramComment*   (^InstagramObjectMapperCommentEntityRequestHandler)     (NSDictionary *commentResponse, BOOL asCaption);

@interface InstagramObjectMapper : NSObject

/**
 *  Retrieves the ID from the response.
 *
 *  @param response NSDictionary of the response to parse.
 *
 *  @return NSString id from the response.
 */
+ (NSString *)extractIDFromResponse:(NSDictionary *)response;


+ (void)mapResponse:(NSDictionary *)response
    toUser:(InstagramUser *)user;

+ (void)mapResponse:(NSDictionary *)response
    toPagination:(InstagramPagination *)pagination;

+ (void)mapResponse:(NSDictionary *)response
    toMedia:(InstagramMedia *)media
    withUserEntityRequestHandler:(InstagramObjectMapperUserEntityRequestHandler)userEntityRequestHandler
    andCommentEntityRequestHandler:(InstagramObjectMapperCommentEntityRequestHandler)commentEntityRequestHandler;

+ (void)mapResponse:(NSDictionary *)response
    toComment:(InstagramComment *)comment
    asCaption:(BOOL)asCaption
    withUserEntityRequestHandler:(InstagramObjectMapperUserEntityRequestHandler)userEntityRequestHandler;

+ (void)mapResponse:(NSDictionary *)response
    toTag:(InstagramTag *)tag;

@end
