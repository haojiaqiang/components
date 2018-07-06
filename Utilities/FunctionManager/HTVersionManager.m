//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTVersionManager.h"
#import "Constants.h"
#import "NSString+Utilities.h"

@implementation HTVersionManager

static HTVersionManager *_sharedInstance = nil;

+ (HTVersionManager *)sharedManager {
    @synchronized([HTVersionManager class]) {
        if (!_sharedInstance)
            _sharedInstance = [[self alloc] init];
        return _sharedInstance;
    }
    return nil;
}

+ (instancetype)alloc {
    @synchronized([HTVersionManager class]) {
        NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedInstance = [super alloc];
        return _sharedInstance;
    }
    return nil;
}

- (BOOL)isNewVersion:(NSString *)version {
    if ([NSString isNullOrEmpty:version]) {
        return NO;
    }
    NSArray *versions = [version splitBy:@"."];
    if (!versions || versions.count == 0) {
        return NO;
    }
    NSArray *currentVerions = [kAppVersion splitBy:@"."];
    if (!currentVerions || currentVerions.count == 0){
        return NO;
    }
    for (int i = 0, n = (int)MIN(versions.count, currentVerions.count); i < n; i++) {
        int v = [[currentVerions objectAtIndex:i] getIntValue];
        int v2 = [[versions objectAtIndex:i] getIntValue];
        if (v > v2) {
            return NO;
        }
        if ( v < v2) {
            return YES;
        }
    }
    if (versions.count > currentVerions.count) {
        for (NSInteger i = currentVerions.count; i < versions.count; i++) {
            int v = [[versions objectAtIndex:i] getIntValue];
            if (v > 0) {
                return YES;
            }
        }
    }
    return NO;
}

@end
