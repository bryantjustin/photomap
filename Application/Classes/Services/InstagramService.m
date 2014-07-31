//
//  InstagramService.m
//  PhotoMap
//
//  Created by Bryant Balatbat on 2014-07-26.
//  Copyright (c) 2014 bryantjustin.com. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "InstagramService.h"
#import "KeychainManager.h"

static const char *const BackgroundQueueLabel   = "com.bryantjustin.photomap.background-queue";

static NSString *const AuthenticationURL        = @"https://api.instagram.com/oauth/authorize/";
static NSString *const TokenURL                 = @"https://api.instagram.com/oauth/access_token/";
static NSString *const RedirectURI              = @"photomap://authentication/";

static NSString *const APIBaseURL               = @"https://api.instagram.com/v1/";
static NSString *const SelfUserDetailEndpoint   = @"users/self";
static NSString *const SelfUserFeedEndpoint         = @"users/self/feed";

static NSString *const ClientID                 = @"75ce3fb35c934fe7b76734f82f54b898";
static NSString *const ClientSecret             = @"b5ba513838544b8db7465cf51012b615";
static NSString *const Scope                    = @"basic";

static NSString *const ParameterDelimiter       = @"&";
static NSString *const KeyValueDelimiter        = @"=";

static NSString *const RedirectURIKey           = @"redirect_uri";
static NSString *const AccessTokenKey           = @"access_token";
static NSString *const ClientIDTokenKey         = @"client_id";
static NSString *const DataKey                  = @"data";
static NSString *const PaginationKey            = @"pagination";
static NSString *const CountKey                 = @"count";
static NSString *const MaxIDKey                   = @"max_id";
static NSString *const MinIDKey                 = @"min_id";

static NSInteger const FeedCount = 20;

@interface InstagramService ()

@property (nonatomic,readonly) NSURL *fullAuthenticationURL;

@end

/******************************************************************************/

#pragma mark - Class Implementation

/******************************************************************************/

@implementation InstagramService
{
    AFHTTPRequestOperationManager *_requestOperationManager;
    dispatch_queue_t _backgroundQueue;
}

+ (instancetype)defaultService
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



/******************************************************************************/

#pragma mark - Properties

/******************************************************************************/

@synthesize fullAuthenticationURL   = _fullAuthenticationURL;
@synthesize accessToken             = _accessToken;

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

- (void)setAccessToken:(NSString *)accessToken
{
    @synchronized(self)
    {
        [KeychainManager.sharedManager
            setString:accessToken
            forKey:InstagramAccessTokenKeychainKey
        ];
        
        _accessToken = accessToken;
    }
}

- (NSString *)accessToken
{
    @synchronized(self)
    {
        if (_accessToken == nil)
        {
            _accessToken = [KeychainManager.sharedManager stringForKey:InstagramAccessTokenKeychainKey];
        }
        return _accessToken;
    }
}

- (BOOL)hasAccessToken
{
    return self.accessToken != nil;
}



/******************************************************************************/

#pragma mark - Init Method

/******************************************************************************/

- (id)init
{
    if (self = [super init])
    {
        [self prepareBackgroundQueue];
        [self prepareRequestOperationManager];
    }
    
    return self;
}

- (void)prepareRequestOperationManager
{
    _requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURL]];
    _requestOperationManager.responseSerializer = [AFJSONResponseSerializer new];
}

- (void)prepareBackgroundQueue
{
    _backgroundQueue = dispatch_queue_create(BackgroundQueueLabel, DISPATCH_QUEUE_SERIAL);
}



/******************************************************************************/

#pragma mark - Destructor

/******************************************************************************/

- (void)dealloc
{
    #if !OS_OBJECT_USE_OBJC
        dispatch_release(_backgroundQueue);
    #endif
    
    _backgroundQueue = nil;
}



/******************************************************************************/

#pragma mark - Login Methods

/******************************************************************************/

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
            self.accessToken = accessToken;
            [NSNotificationCenter.defaultCenter
                postNotificationName:kDidSuccessfullyAuthenticate
                object:nil
            ];
        }
        else
        {
            [NSNotificationCenter.defaultCenter
                postNotificationName:kDidFailToAuthenticate
                object:nil
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
        
        if ([keyValuePairs.firstObject isEqualToString:AccessTokenKey])
        {
            accessToken = keyValuePairs.lastObject;
            break;
        }
    }

    return accessToken;
}



/******************************************************************************/

#pragma mark - Get Feed

/******************************************************************************/

- (void)getSelfUserDetailsWithSuccess:(InstagramServiceDataResponseBlock)success
    failure:(InstagramServiceErrorBlock)failure
{
    NSString *perecentEscapedEndPoint = [SelfUserDetailEndpoint stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *parameters = [self prepareParameters:nil];
    
    [_requestOperationManager
        GET:perecentEscapedEndPoint
        parameters:parameters
        success:^(AFHTTPRequestOperation *operation, id response)
        {
            success(response[DataKey]);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            failure(error);
        }
    ];
}

- (void)getSelfUserFeedWithSuccess:(InstagramServiceDataAndPaginationResponseBlock)success
    failure:(InstagramServiceErrorBlock)failure
{
    NSString *perecentEscapedEndPoint = [SelfUserFeedEndpoint stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *parameters = [self
        prepareParameters:
        @{
            CountKey:@(FeedCount)
        }
    ];
    
    [_requestOperationManager
        GET:perecentEscapedEndPoint
        parameters:parameters
        success:^(AFHTTPRequestOperation *operation, id response)
        {
            success(response[DataKey], response[PaginationKey]);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            failure(error);
        }
    ];
}

- (NSDictionary *)prepareParameters:(NSDictionary *)parameters
{
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (self.hasAccessToken)
    {
        mutableParameters[AccessTokenKey] = self.accessToken;
    }
    
    return [NSDictionary dictionaryWithDictionary:mutableParameters];
}

//
//- (void)getSelfUserFeedWithSuccess:(InstagramMediaBlock)success
//    failure:(InstagramFailureBlock)failure
//{
//    [self getPath:[NSString stringWithFormat:@"users/self/feed"] parameters:nil responseModel:[InstagramMedia class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
//        if(success)
//		{
//			NSArray *objects = response;
//			success(objects, paginationInfo);
//		}
//    } failure:^(NSError *error, NSInteger statusCode) {
//        if(failure)
//		{
//			failure(error);
//		}
//    }];
//}
//
//
//- (void)getSelfUserFeedWithCount:(NSInteger)count
//    maxId:(NSString *)maxId
//    success:(InstagramMediaBlock)success
//    failure:(InstagramFailureBlock)failure
//{
//    NSDictionary *params = [self parametersFromCount:count maxId:maxId andMaxIdType:kPaginationMaxId];
//    [self getPath:[NSString stringWithFormat:@"users/self/feed"] parameters:params responseModel:[InstagramMedia class] success:^(id response, InstagramPaginationInfo *paginationInfo) {
//        if(success)
//		{
//			NSArray *objects = response;
//			success(objects, paginationInfo);
//		}
//    } failure:^(NSError *error, NSInteger statusCode) {
//        if(failure)
//		{
//			failure(error);
//		}
//    }];
//}

@end
