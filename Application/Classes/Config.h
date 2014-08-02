//
//  Config.h
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-26.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

/******************************************************************************/

#pragma mark - Entities

/******************************************************************************/

static NSString *const InstagramUserEntityName     = @"InstagramUser";
static NSString *const InstagramMediaEntityName    = @"InstagramMedia";
static NSString *const InstagramCommentEntityName  = @"InstagramComment";



/******************************************************************************/

#pragma mark - Fonts

/******************************************************************************/

static NSString *const AvenirFont       = @"Avenir";
static NSString *const AvenirRomanFont  = @"Avenir-Roman";
static NSString *const AvenirBookFont   = @"Avenir-Book";
static NSString *const AvenirBlackFont  = @"Avenir-Black";
static NSString *const AvenirMediumFont = @"Avenir-Medium";

static NSString *const AvenirNextLightFont      = @"AvenirNext-Light";
static NSString *const AvenirNextRegularFont    = @"AvenirNext-Regular";
static NSString *const AvenirNextMediumFont     = @"AvenirNext-Medium";
static NSString *const AvenirNextDemiBoldFont   = @"AvenirNext-DemiBold";
static NSString *const AvenirNextBoldFont       = @"AvenirNext-Bold";



/******************************************************************************/

#pragma mark - Colors

/******************************************************************************/

#define DarkGreyColor [UIColor colorWithRed:28./255. green:28./255. blue:28./255. alpha:1.]



/******************************************************************************/

#pragma mark - User Default Keys

/******************************************************************************/

static NSString *const InstagramAccessTokenKeychainKey  = @"InstagramAccessTokenKeychainKey";



/******************************************************************************/

#pragma mark - Events

/******************************************************************************/

static NSString *const kDidSuccessfullyAuthenticate     = @"kDidSuccessfullyAuthenticate";
static NSString *const kDidFailToAuthenticate           = @"kDidFailToAuthenticate";
static NSString *const kDidReceiveAuthenticationError   = @"kDidReceiveAuthenticationError";

static NSString *const kFeedDidUpdate                   = @"kFeedDidUpdate";



/******************************************************************************/

#pragma mark - Event Keys

/******************************************************************************/

static NSString *const UpdatedObjectsKey = @"UpdatedObjectsKey";
