//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTDeviceManager : NSObject

+ (HTDeviceManager *)sharedManager;

- (NSString *)machine; // e.g. @"iPhone3,1", @"iPhone3,2", @"iPhone3,3", @"iPhone4,1", @"iPhone4,2" etc. systemInfo.code

- (NSString *)machineName; // e.g. @"iPhone 4S", @"iPhone 5S", @"iPad Air", etc.

- (NSString *)deviceName; // e.g. @"My iPhone", @"Chris's iPhone", etc. User customize name set in system settings

- (NSString *)deviceModel; // e.g. @"iPhone", @"iPod touch"

- (NSString *)systemName; // e.g. @"iPhone OS", etc. OS System Name

- (NSString *)systemVersion; // e.g. @"9.3.2", etc. OS System version

- (NSString *)deviceUID; // e.g. xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

- (NSString *)carrierName; // e.g. AT&T, China Union, China Mobile, CMHK, Telekom.de, voda AU, etc. cullar provider name

- (BOOL)iPhone35;

- (BOOL)iPhone40;

- (BOOL)iPhone47;

- (BOOL)iPhone55;

@end
