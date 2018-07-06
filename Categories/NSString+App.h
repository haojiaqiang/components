//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (App)

+ (NSString *)currentPlatform;
+ (NSString *)currentAppName;
+ (NSString *)currentBundleVersion;
+ (NSString *)appBundleIdentifier;

@end
