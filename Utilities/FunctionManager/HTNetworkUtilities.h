//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

/* 
#import <Foundation/Foundation.h>

@interface HTNetworkUtilities : NSObject

+ (HTNetworkUtilities*) sharedInstance;

@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;
@property (readonly, nonatomic, assign, getter = isReachableViaWWAN) BOOL reachableViaWWAN;
@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;
@property (readwrite, nonatomic, assign, getter = isRetry, setter = setRetry:) BOOL retry;

+(NSString*)getDeviceId;

- (void) setRetryTimes:(int) retryTimes andRetryInterval:(int) retryInterval;
- (void) get:(NSString*) requestUrl withParameters:(id)parameters onSuccess:(void (^)(id responseData)) success onFailure:(void (^)(NSError* error))failure;
- (void) post:(NSString*) requestUrl withParameters:(id)parameters onSuccess:(void (^)(id responseData)) success onFailure:(void (^)(NSError* error))failure;
- (void) post:(HTRequest*)request forResponseClass:(Class)clazz onSuccess:(void (^)(HTResponse *response)) success onFailure: (void (^)(NSError* error)) failure;
- (void) post:(NSString*) requestUrl withParameters:(id)parameters andMultiParts:(NSDictionary*) multiParts onSuccess:(void (^)(id responseData)) success onFailure:(void (^)(NSError* error))failure;
- (void) abort:(NSString*) requestUrl;

@end
*/
