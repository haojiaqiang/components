//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTVersion.h"
#import "NSString+Utilities.h"

@implementation HTVersion

static HTVersion* _sharedInstance = nil;

+ (instancetype)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

+ (instancetype)sharedVersion {
    return [[self alloc] init];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (BOOL) isNewVersion:(NSString *)version{
    if([NSString isNullOrEmpty:version]){
        return NO;
    }
    NSArray *versions = [version splitBy:@"."];
    if(!versions || versions.count==0){
        return NO;
    }
    NSArray *currentVerions = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] splitBy:@"."];
    if(!currentVerions || currentVerions.count==0){
        return NO;
    }
    for(int i=0,n=(int)MIN(versions.count, currentVerions.count);i<n;i++){
        int v = [[currentVerions objectAtIndex:i] getIntValue];
        int v2 = [[versions objectAtIndex:i] getIntValue];
        if(v<v2){
            return YES;
        }
        if(v>v2) {
            return NO;
        }
    }
    if (versions.count>currentVerions.count) {
        for (NSInteger i=currentVerions.count; i<versions.count; i++) {
            int v = [[versions objectAtIndex:i] getIntValue];
            if (v>0) {
                return YES;
            }
        }
    }
    return NO;
}

- (HTAppVersionCompareResult)compareWithVersion:(NSString *)version {
    if([NSString isNullOrEmpty:version]){
        return HTAppVersionCompareResultNone;
    }
    NSArray *versions = [version splitBy:@"."];
    if(!versions || versions.count == 0){
        return HTAppVersionCompareResultNone;
    }
    NSArray *localVerions = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] splitBy:@"."];
    if(!localVerions || localVerions.count == 0){
        return HTAppVersionCompareResultNone;
    }
    if (versions.count == localVerions.count) {
        for(int i = 0;i < versions.count; i++){
            int v = [[localVerions objectAtIndex:i] getIntValue];
            int v2 = [[versions objectAtIndex:i] getIntValue];
            if(v < v2){
                return HTAppVersionCompareResultLessThan;
            } else if (v > v2) {
                return HTAppVersionCompareResultGreaterThan;
            }
            if ((i == versions.count - 1) && v == v2) {
                return HTAppVersionCompareResultEqualTo;
            }
        }
    } else {
        for (int i = 0; i < MIN(versions.count, localVerions.count); i++) {
            int v = [[localVerions objectAtIndex:i] getIntValue];
            int v2 = [[versions objectAtIndex:i] getIntValue];
            if(v < v2){
                return HTAppVersionCompareResultLessThan;
            } else if (v > v2) {
                return HTAppVersionCompareResultGreaterThan;
            }
            if (i == MIN(versions.count, localVerions.count) - 1){
                return localVerions.count < versions.count ? HTAppVersionCompareResultLessThan : HTAppVersionCompareResultGreaterThan;
            }
        }
    }
    return HTAppVersionCompareResultNone;
}

@end
