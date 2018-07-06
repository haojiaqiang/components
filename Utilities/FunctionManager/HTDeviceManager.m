//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTDeviceManager.h"
#import "SDVersion.h"
#import <UIKit/UIDevice.h>
#import "NSString+Utilities.h"

#import  <CoreTelephony/CTCarrier.h>
#import  <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation HTDeviceManager
{
    NSString *_carrierName;
}

static HTDeviceManager *_sharedInstance = nil;

+ (HTDeviceManager *)sharedManager {
    @synchronized([HTDeviceManager class]) {
        if(!_sharedInstance)
            _sharedInstance = [[self alloc] init];
        return _sharedInstance;
    }
    return nil;
}

+ (id)alloc {
    @synchronized([HTDeviceManager class]) {
        NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedInstance = [super alloc];
        return _sharedInstance;
    }
    return nil;
}

- (NSString *)machine {
    return [SDiOSVersion deviceNameString];
}

- (NSString *)machineName {
    DeviceVersion deviceVersion = [SDiOSVersion deviceVersion];
    return [SDiOSVersion deviceNameForVersion:deviceVersion];
}

- (NSString *)deviceName {
    return [UIDevice currentDevice].name;
}

- (NSString *)systemName {
    return [UIDevice currentDevice].systemName;
}

- (NSString *)systemVersion {
    return [UIDevice currentDevice].systemVersion;
}

- (NSString *)deviceUID {
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}

- (NSString *)deviceModel {
    return [UIDevice currentDevice].model;
}

- (NSString *)carrierName {
    if (!_carrierName) {
        CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc]init];
        CTCarrier*carrier = [netInfo subscriberCellularProvider];
        if (carrier != NULL) {
            _carrierName = [carrier carrierName];
        }
        // Check empty or null
        if ([NSString isNullOrEmpty:_carrierName]) {
            _carrierName = @"";
        }
    }
    return _carrierName;
}

- (BOOL)iPhone35 {
    DeviceSize deviceSize = [SDiOSVersion deviceSize];
    if(deviceSize == Screen3Dot5inch) {
        return YES;
    }
    
    DeviceVersion deviceVersion = [SDiOSVersion deviceVersion];
    if(deviceVersion == iPhone4 ||
       deviceVersion == iPhone4S ||
       deviceVersion == iPodTouch3Gen ||
       deviceVersion == iPodTouch4Gen) {
        return YES;
    }
    return NO;
}

- (BOOL)iPhone40 {
    DeviceSize deviceSize = [SDiOSVersion deviceSize];
    if (deviceSize == Screen4inch) {
        return YES;
    }
    
    DeviceVersion deviceVersion = [SDiOSVersion deviceVersion];
    if(deviceVersion == iPhone5 ||
       deviceVersion == iPhone5C ||
       deviceVersion == iPhone5S ||
       deviceVersion == iPodTouch5Gen ||
       deviceVersion == iPodTouch6Gen ||
       deviceVersion == iPhoneSE) {
        return YES;
    }
    return NO;
}

- (BOOL)iPhone47 {
    DeviceSize deviceSize = [SDiOSVersion deviceSize];
    if (deviceSize == Screen4Dot7inch) {
        return YES;
    }
    
    DeviceVersion deviceVersion = [SDiOSVersion deviceVersion];
    if(deviceVersion == iPhone6 || deviceVersion == iPhone6S || deviceVersion == iPhone7){
        return YES;
    }
    return NO;
}

- (BOOL)iPhone55 {
    DeviceSize deviceSize = [SDiOSVersion deviceSize];
    if (deviceSize == Screen5Dot5inch) {
        return YES;
    }
    
    DeviceVersion deviceVersion = [SDiOSVersion deviceVersion];
    if(deviceVersion == iPhone6Plus || deviceVersion == iPhone6SPlus || deviceVersion == iPhone7Plus){
        return YES;
    }
    return NO;
}

@end
