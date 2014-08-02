//
//  InstagramParser.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-28.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "InstagramObjectMapper.h"

#import "InstagramPagination.h"
#import "InstagramUser.h"
#import "InstagramMedia.h"
#import "InstagramComment.h"
#import "InstagramTag.h"

NSString *const IDKey                   = @"id";
NSString *const UsernameKey             = @"username";
NSString *const FullNameKey             = @"full_name";
NSString *const ProfilePictureURLKey    = @"profile_picture";
NSString *const BioKey                  = @"bio";
NSString *const WebsiteKey              = @"website";

NSString *const CountsKey               = @"counts";
NSString *const MediaCountsKey          = @"media";
NSString *const FollowsCountsKey        = @"follows";
NSString *const FollowedByCountsKey     = @"followed_by";

NSString *const NextURLKey              = @"next_url";
NSString *const NextMaxIDKey            = @"next_max_id";

NSString *const UserKey                 = @"user";
NSString *const FromKey                 = @"from";
NSString *const TextKey                 = @"text";
NSString *const CreatedTimeKey          = @"created_time";

NSString *const CaptionKey              = @"caption";
NSString *const CommentsKey             = @"comments";
NSString *const DataKey                 = @"data";
NSString *const LocationKey             = @"location";
NSString *const LatitudeKey             = @"latitude";
NSString *const LongitudeKey            = @"longitude";
NSString *const ImagesKey               = @"images";
NSString *const VideosKey               = @"videos";
NSString *const ThumbnailKey            = @"thumbnail";
NSString *const LowResolutionKey        = @"low_resolution";
NSString *const StandardResolutionKey   = @"standard_resolution";
NSString *const URLKey                  = @"url";
NSString *const HeightKey               = @"height";
NSString *const WidthKey                = @"width";

NSString *const TypeKey                 = @"type";
NSString *const ImageString             = @"image";
NSString *const VideoString             = @"video";

NSString *const NameKey                 = @"name";
NSString *const MediaCountKey           = @"media_count";

static NSString *const NullString = @"<null>";

@implementation InstagramObjectMapper

+ (BOOL)isValueNonNull:(NSObject *)value
{
    return (value
        && (![value isEqual:[NSNull null]])
        && (![value isEqual:NullString])
    );
}

+ (NSString *)extractIDFromResponse:(NSDictionary *)response
{
    return [NSString stringWithString:response[IDKey]];
}

+ (void)mapResponse:(NSDictionary *)response
    toUser:(InstagramUser *)user
{
    if ([self isValueNonNull:response])
    {
        user.id                         = [NSString stringWithString:response[IDKey]];
        user.username                   = [NSString stringWithString:response[UsernameKey]];
        user.fullName                   = [NSString stringWithString:response[FullNameKey]];
        user.profilePictureURLString    = [NSString stringWithString:response[ProfilePictureURLKey]];
        
        if ([self isValueNonNull:response[BioKey]])
        {
            user.bio = [NSString stringWithString:response[BioKey]];
        }
        
        if ([self isValueNonNull:response[WebsiteKey]])
        {
            user.websiteURLString = [NSString stringWithString:response[WebsiteKey]];
        }
        
        if ([self isValueNonNull:CountsKey])
        {
            user.mediaCount         = response[CountsKey][CountsKey];
            user.followsCount       = response[CountsKey][FollowsCountsKey];
            user.followedByCount    = response[CountsKey][FollowedByCountsKey];
        }
    }
}

+ (void)mapResponse:(NSDictionary *)response
    toPagination:(InstagramPagination *)pagination
{
    if ([self isValueNonNull:response])
    {
        pagination.nextURL = [NSURL URLWithString:response[NextURLKey]];
        if ([self isValueNonNull:NextMaxIDKey])
        {
            pagination.nextMaxId = [NSString stringWithString:response[NextMaxIDKey]];
        }
    }
}

+ (void)mapResponse:(NSDictionary *)response
    toMedia:(InstagramMedia *)media
    withUserEntityRequestHandler:(InstagramObjectMapperUserEntityRequestHandler)userEntityRequestHandler
    andCommentEntityRequestHandler:(InstagramObjectMapperCommentEntityRequestHandler)commentEntityRequestHandler
{
    if ([self isValueNonNull:response])
    {
        media.id            = [NSString stringWithString:response[IDKey]];
        media.createdDate   = [NSDate dateWithTimeIntervalSince1970:[response[CreatedTimeKey] doubleValue]];
        media.user          = userEntityRequestHandler(response[UserKey]);
        
        NSDictionary *captionResponse = response[CaptionKey];
        if ([self isValueNonNull:captionResponse])
        {
            media.caption = commentEntityRequestHandler(captionResponse, YES);
        }
        
        NSArray *commentResponses = response[CommentsKey][DataKey];
        for (NSDictionary *commentResponse in commentResponses)
        {
            [media addCommentsObject:commentEntityRequestHandler(commentResponse, NO)];
        }
        
        NSDictionary *locationResponse = response[LocationKey];
        if ([self isValueNonNull:locationResponse])
        {
            media.latitude      = locationResponse[LatitudeKey];
            media.longtitude    = locationResponse[LongitudeKey];
        }
        
        // Parse images response
        
        NSDictionary *imagesResponse = response[ImagesKey];
        if ([self isValueNonNull:imagesResponse])
        {
            NSDictionary *thumbnailResponse = imagesResponse[ThumbnailKey];
            if ([self isValueNonNull:thumbnailResponse])
            {
                media.thumbnailURLString    = thumbnailResponse[URLKey];
                media.thumbnailSizeString   = NSStringFromCGSize(
                    CGSizeMake(
                        [thumbnailResponse[WidthKey] floatValue],
                        [thumbnailResponse[HeightKey] floatValue]
                    )
                );
            }
            
            NSDictionary *lowResolutionResponse = imagesResponse[LowResolutionKey];
            if ([self isValueNonNull:lowResolutionResponse])
            {
                media.lowResolutionImageURLString   = lowResolutionResponse[URLKey];
                media.lowResolutionImageSizeString  = NSStringFromCGSize(
                    CGSizeMake(
                        [lowResolutionResponse[WidthKey] floatValue],
                        [lowResolutionResponse[HeightKey] floatValue]
                    )
                );
            }
            
            NSDictionary *standardResolutionResponse = imagesResponse[StandardResolutionKey];
            if ([self isValueNonNull:standardResolutionResponse])
            {
                media.standardResolutionImageURLString   = standardResolutionResponse[URLKey];
                media.standardResolutionImageSizeString  = NSStringFromCGSize(
                    CGSizeMake(
                        [standardResolutionResponse[WidthKey] floatValue],
                        [standardResolutionResponse[HeightKey] floatValue]
                    )
                );
            }
        }
        
        BOOL isVideo = [response[TypeKey] isEqualToString:VideoString];
        media.type = isVideo ? @(InstagramMediaTypeVideo) : @(InstagramMediaTypeImage);
        
        // Parse videos response
        
        if (isVideo)
        {
            NSDictionary *videosResponse = response[ImagesKey];
            if ([self isValueNonNull:videosResponse])
            {
                NSDictionary *lowResolutionResponse = videosResponse[LowResolutionKey];
                if ([self isValueNonNull:lowResolutionResponse])
                {
                    media.lowResolutionVideoURLString   = lowResolutionResponse[URLKey];
                    media.lowResolutionVideoSizeString  = NSStringFromCGSize(
                        CGSizeMake(
                            [lowResolutionResponse[WidthKey] floatValue],
                            [lowResolutionResponse[HeightKey] floatValue]
                        )
                    );
                }
                
                NSDictionary *standardResolutionResponse = videosResponse[StandardResolutionKey];
                if ([self isValueNonNull:standardResolutionResponse])
                {
                    media.standardResolutionVideoURLString   = standardResolutionResponse[URLKey];
                    media.standardResolutionVideoSizeString  = NSStringFromCGSize(
                        CGSizeMake(
                            [standardResolutionResponse[WidthKey] floatValue],
                            [standardResolutionResponse[HeightKey] floatValue]
                        )
                    );
                }
            }
        }
    }
}

+ (void)mapResponse:(NSDictionary *)response
    toComment:(InstagramComment *)comment
    asCaption:(BOOL)asCaption
    withUserEntityRequestHandler:(InstagramObjectMapperUserEntityRequestHandler)userEntityRequestHandler;
{
    if ([self isValueNonNull:response])
    {
        comment.id          = [NSString stringWithString:response[IDKey]];
        comment.text        = [NSString stringWithString:response[TextKey]];
        comment.createdDate = [NSDate dateWithTimeIntervalSince1970:[response[CreatedTimeKey] doubleValue]];
        comment.user        = userEntityRequestHandler(response[FromKey]);
        comment.type        = asCaption ? @(CommentTypeCaption) : @(CommentTypeDefault);
    }
}

+ (void)mapResponse:(NSDictionary *)response
    toTag:(InstagramTag *)tag
{
    if ([self isValueNonNull:response])
    {
        tag.name = [NSString stringWithString:response[NameKey]];
        tag.mediaCount = [NSString stringWithString:response[MediaCountKey]].integerValue;
    }
}
@end
