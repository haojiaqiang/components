//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTLocalSettings.h"
#import "NSString+Utilities.h"

@implementation HTLocalSettings

static HTLocalSettings *_sharedInstance = nil;

+ (instancetype)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

+ (instancetype)sharedSettings {
    return [[self alloc] init];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (id)settingsForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)setSettings:(id)settings forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeSettingsForKey:(NSString *)key {
    if (![NSString isNullOrEmpty:key]){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (BOOL)hasSettingForKey:(NSString *)key {
    return [self settingsForKey:key]? YES : NO;
}

@end
