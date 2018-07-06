//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTNetworkManager.h"
#import "HTRequest.h"
#import "HTResponse.h"
#import "AFNetworking.h"

@implementation HTNetworkManager
{
    NSMutableDictionary *_url2Tasks;
    AFHTTPSessionManager *_sessionManager;
}

static HTNetworkManager *_sharedInstance = nil;


+ (HTNetworkManager *)sharedManager {
    @synchronized([HTNetworkManager class]) {
        if (!_sharedInstance) {
            _sharedInstance = [[self alloc] init];
        }
        if (_sharedInstance) {
            [_sharedInstance prepareNetworkManager];
        }
        return _sharedInstance;
    }
    return nil;
}

+ (instancetype)alloc {
    @synchronized([HTNetworkManager class]) {
        NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedInstance = [super alloc];
        return _sharedInstance;
    }
    return nil;
}

- (void)prepareNetworkManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
#ifdef APP_DEBUG
        {// SSL certificate
            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
            // 如果是需要验证自建证书，需要设置为YES
            securityPolicy.allowInvalidCertificates = YES;
            [securityPolicy setValidatesDomainName:NO];
            [_sessionManager setSecurityPolicy:securityPolicy];
        }
#endif
    }
    if (!_url2Tasks) {
        _url2Tasks = [NSMutableDictionary dictionary];
    }
}

- (void)get:(HTRequest *)request forResponseClass:(Class)clazz success:(void (^)(HTResponse *))success failure:(void (^)(NSError *))failure {
    [self get:request forResponseClass:clazz progress:nil success:success failure:failure];
}

- (void)post:(HTRequest *)request forResponseClass:(Class)clazz success:(void (^)(HTResponse *))success failure:(void (^)(NSError *))failure {
    [self post:request forResponseClass:clazz progress:nil success:success failure:failure];
}

- (void)get:(HTRequest *)request forResponseClass:(Class)clazz progress:(void (^)(NSProgress *))progress success:(void (^)(HTResponse *))success failure:(void (^)(NSError *))failure {

    [self prepareHttpHeaders:request];
    
    __weak typeof(self) weakSelf = self;

    [_url2Tasks setObject:
    [_sessionManager GET:request.url parameters:request.parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            HTResponse *response = [[clazz alloc] initWithDictionary:responseObject];
            if (response && request.enableResponseObject) {
                [response setValue:responseObject forKey:@"responseObject"];
            }
            success(response);
            [weakSelf handleRequestSuccess:request];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        [weakSelf handleRequestFailure:request];
    }] forKey:request.url];
}

- (void)handleRequestSuccess:(HTRequest *)request {
    [_url2Tasks removeObjectForKey:request.url];
}

- (void)handleRequestFailure:(HTRequest *)request {
    [_url2Tasks removeObjectForKey:request.url];
}

- (void)post:(HTRequest *)request forResponseClass:(Class)clazz progress:(void (^)(NSProgress *))progress success:(void (^)(HTResponse *))success failure:(void (^)(NSError *))failure {
    
    [self prepareHttpHeaders:request];
    
    __weak typeof(self) weakSelf = self;
    
    [_url2Tasks setObject:
    [_sessionManager POST:request.url parameters:request.parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            HTResponse *response = [[clazz alloc] initWithDictionary:responseObject];
            if (response && request.enableResponseObject) {
                [response setValue:responseObject forKey:@"responseObject"];
            }
            success(response);
            [weakSelf handleRequestFailure:request];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        [weakSelf handleRequestFailure:request];
    }] forKey:request.url];
}

- (void)prepareHttpHeaders:(HTRequest *)request {
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    
    [requestSerializer setTimeoutInterval:[request timeoutInterval]];
    
    NSDictionary *headers = [request headers];
    if (headers) {
        for (NSInteger i = 0, n = headers.allKeys.count; i < n; ++ i) {
            NSString *key = [headers.allKeys objectAtIndex:i];
            [requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    if (request.acceptContentTypes) {
        [responseSerializer setAcceptableContentTypes:request.acceptContentTypes];
    }
    
    _sessionManager.requestSerializer = requestSerializer;
    _sessionManager.responseSerializer = responseSerializer;
}

- (void)abort:(NSString *)url {
    NSURLSessionDataTask *task = [_url2Tasks objectForKey:url];
    if (task) {
        [task cancel];
        [_url2Tasks removeObjectForKey:url];
    }
}

@end
