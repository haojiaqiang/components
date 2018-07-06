//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTLocalSettings.h"
#import "NSString+Utilities.h"

@implementation HTLocalSettings

static HTLocalSettings *_sharedInstance = nil;

+ (HTLocalSettings *)sharedSettings {
    @synchronized([HTLocalSettings class]) {
        if(!_sharedInstance)
            _sharedInstance = [[self alloc] init];
        return _sharedInstance;
    }
    return nil;
}

+ (instancetype)alloc {
    @synchronized([HTLocalSettings class]) {
        NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedInstance = [super alloc];
        return _sharedInstance;
    }
    return nil;
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
