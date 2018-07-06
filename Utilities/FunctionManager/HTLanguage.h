//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HT_CUSTOME_LANGUAGE_KEY @"CustomAppLanguage"

@interface HTLanguage : NSObject

+ (HTLanguage *)sharedInstance;

- (void)setLanguage:(NSString *)language;

- (NSString *)getLanguage;

- (NSArray *)availableLanguages;

@end
