//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTNetworkReachabilityManager.h"
#import "AFNetworking.h"

@implementation HTNetworkReachabilityManager

static HTNetworkReachabilityManager *_sharedInstance;

+ (instancetype)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

+ (instancetype)sharedManager {
    return [[self alloc] init];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (void)startReachabilityMonitor:(void (^)(HTNetworkReachabilityStatus))callback {
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [weakSelf handleReachabilityStatusChange:status callback:callback];
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)handleReachabilityStatusChange:(AFNetworkReachabilityStatus)status callback:(void (^)(HTNetworkReachabilityStatus))callback {
    if (callback) {
        callback([self statusFromAFStatus:status]);
    }
}

- (HTNetworkReachabilityStatus)statusFromAFStatus:(AFNetworkReachabilityStatus)status {
    if (status == AFNetworkReachabilityStatusNotReachable) {
        return HTNetworkReachabilityStatusUnknown;
    }
    else if (status == AFNetworkReachabilityStatusNotReachable) {
        return HTNetworkReachabilityStatusNotReachable;
    }
    else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
        return HTNetworkReachabilityStatusReachableViaWiFi;
    }
    else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
        return HTNetworkReachabilityStatusReachableViaWWAN;
    }
    return HTNetworkReachabilityStatusUnknown;
}

- (BOOL)isReachable {
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
}

- (BOOL)isReachableViaWWAN {
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWWAN];
}

- (BOOL)isReachableViaWiFi {
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
}

@end
