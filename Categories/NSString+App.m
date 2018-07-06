//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "NSString+App.h"

@implementation NSString (App)

+ (NSString *)currentPlatform {
    static NSString *currentPlatform = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if TARGET_OS_WATCH
        currentPlatform = @"watchOS";
#elif TARGET_OS_TV
        currentPlatform = @"tvOS";
#elif TARGET_OS_IOS
        currentPlatform = @"ios";
#elif TARGET_OS_MAC
        currentPlatform = @"macOS";
#endif
    });
    return currentPlatform;
}

+ (NSString *)currentAppName {
    static NSString *currentAppName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *bundleID = [NSString appBundleIdentifier];
        if ([bundleID hasPrefix:@"com.lifang.client"]) {
            currentAppName = @"wkzf";
        }
    });
    return currentAppName;
}

+ (NSString *)currentBundleVersion {
    static NSString *bundleVersion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    });
    return bundleVersion;
}

+ (NSString *)appBundleIdentifier {
    static NSString * bundleID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    });
    return bundleID;
}

@end
