//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "HTLocation.h"

@interface HTLocationManager : NSObject

+ (HTLocationManager*) sharedManager;

- (void) reverseGeoLoc:(CLLocation *)loc onCompletion:(void(^)(HTLocation *location)) completion;

- (void) locateCityOnCompletion:(void(^)(HTLocation *location)) completion;

- (void) locateOnCompletion:(void(^)(CLLocation *location)) completion;

- (void) locateDidFailWithError:(void(^)(NSError *error)) hanldeLocateDidFail;

- (void) locatedDidChangeAuthorizationStatus:(void(^)(CLAuthorizationStatus status)) handledocatedDidChangeAuthorizationStatus;

- (CLAuthorizationStatus)authorizationStatus;

- (BOOL)isLocationServicesAvailable;

@end
