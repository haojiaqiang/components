//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTObject.h"

typedef NS_ENUM(NSInteger, HTAppVersionCompareResult) {
    HTAppVersionCompareResultNone = -1,
    HTAppVersionCompareResultLessThan = 1,
    HTAppVersionCompareResultEqualTo,
    HTAppVersionCompareResultGreaterThan
};

@interface HTVersion : HTObject

+ (HTVersion*) sharedVersion;
- (BOOL) isNewVersion:(NSString*) version;
- (HTAppVersionCompareResult)compareWithVersion:(NSString *)version;

@end
