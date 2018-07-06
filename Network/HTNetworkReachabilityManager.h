//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HTNetworkReachabilityStatus) {
    HTNetworkReachabilityStatusUnknown          = -1,
    HTNetworkReachabilityStatusNotReachable     = 0,
    HTNetworkReachabilityStatusReachableViaWWAN = 1,
    HTNetworkReachabilityStatusReachableViaWiFi = 2,
};

@interface HTNetworkReachabilityManager : NSObject

@property (nonatomic, assign, readonly, getter = isReachable) BOOL reachable;

@property (nonatomic, assign, readonly, getter = isReachableViaWWAN) BOOL reachableViaWWAN;

@property (nonatomic, assign, readonly, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

+ (HTNetworkReachabilityManager *)sharedManager;

- (void)startReachabilityMonitor:(void(^)(HTNetworkReachabilityStatus status))callback;

@end
