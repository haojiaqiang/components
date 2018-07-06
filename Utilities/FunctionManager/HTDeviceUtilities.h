//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDVersion.h"

@interface HTDeviceUtilities : NSObject
{
    NSString *_deviceType;
    NSString *_systemVersion;
    NSString *_deviceUid;
    NSString *_cellularProviderName;
    NSString *_imei;
    NSString *_deviceName;
}
@property (nonatomic, strong, readonly, getter = getDeviceType) NSString *deviceType;
@property (nonatomic, strong, readonly, getter = getSystemName) NSString *systemName;
@property (nonatomic, strong, readonly, getter = getSystemVersion) NSString *systemVersion;
@property (nonatomic, assign, readonly, getter = getSystemMajorVersion) NSInteger systemMajorVersion;
@property (nonatomic, strong, readonly, getter = getDeviceUid) NSString *deviceUid;
@property (nonatomic, strong, readonly, getter = getCellularProviderName) NSString *cellularProviderName;
@property (nonatomic, strong, readonly, getter = getIMEI) NSString *imei;
@property (nonatomic, strong, readonly, getter = getModel) NSString *model;
@property (nonatomic, strong, readonly, getter = getDeviceName) NSString *deviceName;
@property (nonatomic, strong, readonly) NSString *idfa;

+ (HTDeviceUtilities*)sharedInstance;

- (NSString *)getIPAddress;

- (BOOL) limitAdTracking;

- (BOOL) iPhoneX;

- (BOOL) iPhonePlus;

- (BOOL) iPhone6;

- (BOOL) iPhone5;

- (BOOL) iPhone4;

/** use @3x image ,such as iPhonePlus and iPhoneX **/
- (BOOL)ultraRetina;

@end
