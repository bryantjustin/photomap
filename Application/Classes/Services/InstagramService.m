//
//  InstagramService.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-26.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import "InstagramService.h"
#import "UserModel.h"

static NSString *const ParameterDelimiter   = @"&";
static NSString *const KeyValueDelimiter    = @"=";

static NSString *const RedirectURIParamKey  = @"redirect_uri";
static NSString *const AccessTokenParamKey  = @"access_token";


static NSString *const AuthenticationURL    = @"https://api.instagram.com/oauth/authorize/";
static NSString *const TokenURL             = @"https://api.instagram.com/oauth/access_token/";
static NSString *const RedirectURI          = @"photomap://authentication/";

static NSString *const ClientID             = @"75ce3fb35c934fe7b76734f82f54b898";
static NSString *const ClientSecret         = @"b5ba513838544b8db7465cf51012b615";
static NSString *const Scope                = @"basic";



/******************************************************************************/

#pragma mark - Class Implementation

/******************************************************************************/

@implementation InstagramService

+ (instancetype)sharedService
{
    static dispatch_once_t onceToken = 0;
    static id instance = nil;
    
    dispatch_once(
        &onceToken,
        ^(void)
        {
            instance = [self new];
        }
    );
    
    return instance;
}

@synthesize fullAuthenticationURL = _fullAuthenticationURL;
- (NSURL *)fullAuthenticationURL
{
    if (_fullAuthenticationURL == nil)
    {
        NSString *fullAuthenticationURLString = [NSString stringWithFormat:
            @"%@?client_id=%@&redirect_uri=%@&scope=%@&response_type=token&display=touch",
            AuthenticationURL,
            ClientID,
            RedirectURI,
            Scope
        ];
        _fullAuthenticationURL = [NSURL URLWithString:fullAuthenticationURLString];
    }
    
    return _fullAuthenticationURL;
}

- (void)login
{
    [[UIApplication sharedApplication] openURL:self.fullAuthenticationURL];
}

- (BOOL)application:(UIApplication *)application
    openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
    annotation:(id)annotation
{
    NSURL *redirectURL = [NSURL URLWithString:RedirectURI];
    
    BOOL willHandleRedirectURL = [redirectURL.scheme isEqual:url.scheme] && [redirectURL.host isEqual:url.host];
    if (willHandleRedirectURL)
    {
        NSString* accessToken = [self accesTokenFromRedirectURI:url];
        if (accessToken)
        {
            UserModel.sharedModel.accessToken = accessToken;
            [NSNotificationCenter.defaultCenter
                postNotificationName:kDidSuccessfullyAuthenticate
                object:self
            ];
        }
        else
        {
            [NSNotificationCenter.defaultCenter
                postNotificationName:kDidFailToAuthenticate
                object:self
            ];
        }
    }
    return willHandleRedirectURL;
}

- (NSString *)accesTokenFromRedirectURI:(NSURL*)redirectURI
{
    NSString *accessToken = nil;
    NSArray *parameters = [redirectURI.fragment componentsSeparatedByString:ParameterDelimiter];
    for (NSString *parameter in parameters)
    {
        NSArray *keyValuePairs = [parameter componentsSeparatedByString:KeyValueDelimiter];
        
        if ([keyValuePairs.firstObject isEqualToString:AccessTokenParamKey])
        {
            accessToken = keyValuePairs.lastObject;
            break;
        }
    }

    return accessToken;
}

@end
