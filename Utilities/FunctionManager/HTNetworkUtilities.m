//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//
/*
#import "HTNetworkUtilities.h"
#import "AFNetworking.h"
#import "HTDeviceUtilities.h"
#import "LFServerBaseInfoHandle.h"
#import "SSKeychain.h"

#define REQUEST_TIMEOUT_LIMIT 30
#define REQUEST_DEFAULT_RETRY_TIMES 3
#define REQUEST_DEFAULT_RETRY_INTERVAL 0
#define REQUEST_CALLBACK_RAND_NUMBER 10

static NSString *HEADER_SECRET     = @"App-Secret";
static NSString *HEADER_DEVICE_ID  = @"deviceId";
static NSString *md5Signature = @"8303b51da8682ade07a24bfaa9e69922"; //TO DO

@implementation HTNetworkUtilities
static HTNetworkUtilities *_sharedInstance;
static int _retryTimes, _retryInterval;
static NSMutableDictionary *_url2Managers;
static BOOL _retry;

+ (HTNetworkUtilities*) sharedInstance{
    @synchronized([HTNetworkUtilities class])
	{
        if(!_sharedInstance)
            _sharedInstance = [[self alloc]init];
        return _sharedInstance;
    }
    return nil;
}

- (instancetype) init{
    self = [super init];
    if(self){
        _retryTimes = 0;
        _retryInterval = 0;
        _retry = NO;
        _url2Managers = [NSMutableDictionary dictionary];
        __weak id weakSelf = self;
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [weakSelf handleReachabilityStatusChange: status];
        }];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

+ (id) alloc{
    @synchronized([HTNetworkUtilities class])
	{
		NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedInstance = [super alloc];
		return _sharedInstance;
	}
	return nil;
}

- (void) handleReachabilityStatusChange: (AFNetworkReachabilityStatus) status{
    //DLog(@"############# Status : %ld", (long)status);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNetworkReachabilityStatus object:[NSNumber numberWithInteger:status]];
}

- (BOOL) isReachable{
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
}

- (BOOL) isReachableViaWiFi{
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
}

- (BOOL) isReachableViaWWAN{
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWWAN];
}

- (void) setRetryTimes:(int)retryTimes andRetryInterval:(int)retryInterval{
    _retryTimes = retryTimes;
    _retryInterval = retryInterval;
}

- (int) getRetryTimes{
    if(!_retry){
        return 0;
    }
    if(_retryTimes>0){
        return _retryTimes;
    }
    return REQUEST_DEFAULT_RETRY_TIMES;
}

- (int) getRetryInterval{
    if(!_retry){
        return 0;
    }
    if(_retryInterval){
        return _retryInterval;
    }
    return REQUEST_DEFAULT_RETRY_INTERVAL;
}

- (void) setRetry:(BOOL)retry{
    _retry = retry;
}

- (BOOL) isRetry{
    return _retry;
}

- (id) getParameterValue:(id) value{
    if([value isKindOfClass:[NSArray class]]){
        NSArray *arr = (NSArray*)value;
        NSString *s = [NSString stringWithFormat:@"%@", [arr join:@","]];
        return s;
    }
    return value;
}

-(void) setRequestHeader:(AFHTTPRequestOperationManager*)manager parameters:(NSMutableDictionary*)parameters{
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    double timestamp = [[NSDate new] timeIntervalSince1970] * 1000;
    NSString *md5 = md5Signature;
    
    [manager.requestSerializer setValue:bundleIdentifier forHTTPHeaderField:@"app"];
    [manager.requestSerializer setValue:md5 forHTTPHeaderField:HEADER_SECRET];
    [manager.requestSerializer setValue:[HTNetworkUtilities getDeviceId] forHTTPHeaderField:HEADER_DEVICE_ID];
    [manager.requestSerializer setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"systemVersion"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"os"];
    [manager.requestSerializer setValue:kAppVersion forHTTPHeaderField:@"version"];
    
    NSString *idfa = [TWDeviceUtilities sharedInstance].idfa;
    if (![NSString isNullOrEmpty:idfa]) {
        [manager.requestSerializer setValue: idfa forHTTPHeaderField:@"muid"];
    }
    
    // Add guestId, login key, use LFApplication here, that's a bad way
    if (![[LFApplication sharedApplication] isGuest]) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%d", [LFApplication sharedApplication].user.guestInfo.guestId]
                         forHTTPHeaderField:@"guestId"];
        [manager.requestSerializer setValue:[LFApplication sharedApplication].user.guestInfo.loginKey
                         forHTTPHeaderField:@"token"];
        [manager.requestSerializer setValue:[LFApplication sharedApplication].user.guestInfo.phoneNum.md5
                         forHTTPHeaderField:@"userMobile"];
        
        // For new house recommendation
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%d", [LFApplication sharedApplication].user.guestInfo.guestId]
                         forHTTPHeaderField:@"User-ID"];
    }
}

- (BOOL) isCallbackRequest:(NSString*) requestUrl{
    return NO;//![NSString isNullOrEmpty:kApiCallbackReport] && [kAppApi(kApiCallbackReport) isEqualToString: requestUrl];
}

- (void) requestCallback:(NSString*) requestUrl responseTime:(NSInteger) responseTime result:(NSInteger) result errorMessage:(NSString*) errorMessage{
}

- (void) showNetworkActivityIndicatorVisible:(BOOL) show{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:show];
}

- (void) checkCallback:(NSString*) requestUrl beginTime:(NSInteger) beginTime error:(NSError*) error{
    unsigned int rand = arc4random()%REQUEST_CALLBACK_RAND_NUMBER;
    if(rand==0){
        NSInteger tm = [[NSDate date] timeIntervalSince1970] - beginTime;
        NSInteger result = 1;
        NSString *errorMessage = nil;
        if(error){
            errorMessage = error.localizedDescription;
            if(error.code==-1001){
                result = 2;
            }else{
                result = 3;
            }
        }
        [self requestCallback:requestUrl responseTime:tm result:result errorMessage:errorMessage];
    }
}

- (void) get:(NSString *)requestUrl withParameters:(id) parameters onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure{
    if(!requestUrl || [NSString isNullOrEmpty:requestUrl]){
        return;
    }
    AFHTTPRequestOperationManager *manager = [_url2Managers objectForKey:requestUrl];
    if(!manager){
        manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer =[AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"json" forHTTPHeaderField:@"Data-Type"];
        [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
        [manager.requestSerializer setTimeoutInterval:REQUEST_TIMEOUT_LIMIT];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        
        [_url2Managers setObject:manager forKey:requestUrl];
    }
    
    [self setRequestHeader:manager parameters:parameters];

    __weak id weakSelf = self;
    NSInteger beginTime = [[NSDate date] timeIntervalSince1970];
    if(![self isCallbackRequest:requestUrl]){
        [self showNetworkActivityIndicatorVisible:YES];
    }
    [manager GET:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![weakSelf isCallbackRequest: requestUrl])
        {
            [weakSelf showNetworkActivityIndicatorVisible:NO];
            [weakSelf checkCallback:requestUrl beginTime:(NSInteger) beginTime error:nil];
            if(success){
                success(responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf showNetworkActivityIndicatorVisible:NO];
        if(![weakSelf isCallbackRequest: requestUrl])
        {
            [weakSelf checkCallback:requestUrl beginTime:(NSInteger) beginTime error:nil];
            if(error.code==-999){
                //Request Aborted
            }else{
                if(failure){
                    failure(error);
                }
            }
        }
    } autoRetry:[self getRetryTimes] retryInterval:[self getRetryInterval]];
}

- (void) post:(NSString *)requestUrl withParameters:(id) parameters onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure{
    if(!requestUrl || [NSString isNullOrEmpty:requestUrl]){
        return;
    }
    AFHTTPRequestOperationManager *manager = [_url2Managers objectForKey:requestUrl];
    if(!manager){
        manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer =[AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"json" forHTTPHeaderField:@"Data-Type"];
        [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
        [manager.requestSerializer setTimeoutInterval:REQUEST_TIMEOUT_LIMIT];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/plain", @"image/jpeg", @"application/json", nil]];
        
        [_url2Managers setObject:manager forKey:requestUrl];
    }
    [self setRequestHeader:manager parameters:parameters];
    
    __weak id weakSelf = self;
    NSInteger beginTime = [[NSDate date] timeIntervalSince1970];
    if (![self isCallbackRequest:requestUrl]) {
        [self showNetworkActivityIndicatorVisible:YES];
    }
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![weakSelf isCallbackRequest: requestUrl])
        {
            [weakSelf showNetworkActivityIndicatorVisible:NO];
            [weakSelf checkCallback:requestUrl beginTime:(NSInteger) beginTime error:nil];
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
            {
                if ([[responseObject objectForKey:@"status"] integerValue]==-1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReLoginRequired object:responseObject];
                    return;
                }
            }
            if(success){
                // Only work for wkzf, account login by other device
                success(responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(![weakSelf isCallbackRequest: requestUrl])
        {
            [weakSelf showNetworkActivityIndicatorVisible:NO];
            [weakSelf checkCallback:requestUrl beginTime:(NSInteger) beginTime error:error];
            if(error.code==-999){
                //Request aborted
            }
            else
            {
                if(failure){
                    failure(error);
                }
            }
        }
    }
   // autoRetry:[self getRetryTimes] retryInterval:[self getRetryInterval] ];
}

- (void) post:(HTRequest*)request forResponseClass:(Class)clazz onSuccess:(void (^)(HTResponse *response)) success onFailure: (void (^)(NSError* error)) failure {
    NSDictionary *parameters = [request toDictionary];
    [self post:[request getFullPath] withParameters: parameters onSuccess:^(id responseData) {
        if (success && [clazz isSubclassOfClass:[HTResponse class]]) {
            HTResponse *response = [[clazz alloc] initWithDictionary:responseData];
            success(response);
        }
    } onFailure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

- (void) post:(NSString *)requestUrl withParameters:(id)parameters andMultiParts:(NSDictionary *)multiParts onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure{
    if(!requestUrl || [NSString isNullOrEmpty:requestUrl]){
        return;
    }
    AFHTTPRequestOperationManager *manager = [_url2Managers objectForKey:requestUrl];
    if (!manager) {
        manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer =[AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"json" forHTTPHeaderField:@"Data-Type"];
        [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
        [manager.requestSerializer setTimeoutInterval:REQUEST_TIMEOUT_LIMIT];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"text/plain", nil]];
        
        [_url2Managers setObject:manager forKey:requestUrl];
    }
    
    [self setRequestHeader:manager parameters:parameters];
    
    __weak id weakSelf = self;
    NSInteger beginTime = [[NSDate date] timeIntervalSince1970];
    if(![self isCallbackRequest:requestUrl]){
        [self showNetworkActivityIndicatorVisible:YES];
    }
    [manager POST:requestUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(multiParts){
            for(id key in multiParts){
                id v = [multiParts objectForKey:key];
                if ([v isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *valueDictionary = (NSDictionary*)v;
                    id value = [valueDictionary valueForKey:@"value"];
                    NSString *mimeType = [valueDictionary valueForKey:@"mimeType"];
                    NSString *fileName = [valueDictionary valueForKey:@"fileName"];
                    if([value isKindOfClass:[NSURL class]]){
                        if (mimeType && fileName) {
                            [formData appendPartWithFileURL:value name:key fileName:fileName mimeType:mimeType error:nil];
                        }else{
                            [formData appendPartWithFileURL:value name:key error:nil];
                        }
                    }
                    else if([value isKindOfClass:[NSData class]]){
                        if (mimeType && fileName) {
                            [formData appendPartWithFileData:value name:key fileName:fileName mimeType:mimeType];
                        }
                        else {
                            [formData appendPartWithFormData:value name:key];
                        }
                    }
                }
                else if ([v isKindOfClass:[NSURL class]]) {
                    [formData appendPartWithFileURL:v name:key error:nil];
                }
                else if ([v isKindOfClass:[NSData class]]) {
                    [formData appendPartWithFormData:v name:key];
                }
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(![weakSelf isCallbackRequest: requestUrl])
        {
            [weakSelf showNetworkActivityIndicatorVisible:NO];
            [weakSelf checkCallback:requestUrl beginTime:(NSInteger) beginTime error:nil];
            if(success){
                success(responseObject);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(![weakSelf isCallbackRequest:requestUrl])
        {
            [weakSelf showNetworkActivityIndicatorVisible:NO];
            [weakSelf checkCallback:requestUrl beginTime:(NSInteger) beginTime error:nil];
            if(error.code==-999){
                //Request Aborted
            }else{
                if(failure){
                    failure(error);
                }
            }
        }
    } autoRetry:[self getRetryTimes] retryInterval:[self getRetryInterval]];
}

- (void) abort:(NSString *)requestUrl{
    if(!requestUrl || [NSString isNullOrEmpty:requestUrl]){
        return;
    }
    AFHTTPRequestOperationManager *manager = [_url2Managers objectForKey:requestUrl];
    if(manager){
        [manager.operationQueue cancelAllOperations];
    }
}

+(NSString*)getDeviceId {
    NSError *error;
    // Look up
    SSKeychainQuery *query = [[SSKeychainQuery alloc] init];
    query.service = kSSKeychainServiceName;
    query.account = kSSKeychainAccountName;
    query.password = nil;
    
    [query fetch:&error];
    if (error) {
        DLog(@"Network -- Unable to fetch keychain item: %@", error);
    }
    return query.password;
}

- (void) dealloc
{
#if __has_feature(objc_arc)
#else
    [super dealloc];
#endif
}

@end
*/
