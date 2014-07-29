//
//  InstagramUser.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-27.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "InstagramUser.h"
#import "InstagramComment.h"
#import "InstagramMedia.h"

@implementation InstagramUser

@dynamic id;
@dynamic username;
@dynamic fullName;
@dynamic profilePictureURLString;
@dynamic bio;
@dynamic websiteURLString;
@dynamic mediaCount;
@dynamic followsCount;
@dynamic followedByCount;
@dynamic isSelf;
@dynamic comments;
@dynamic media;

- (NSURL *)profilePictureURL
{
    return [NSURL URLWithString:self.profilePictureURLString];
}

- (NSURL *)websiteURL
{
    return [NSURL URLWithString:self.websiteURLString];
}

@end
