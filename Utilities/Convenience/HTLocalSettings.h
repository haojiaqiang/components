//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTLocalSettings : NSObject

+ (HTLocalSettings *)sharedSettings;

- (id)getSettings:(NSString*) key;

- (void)setSettings:(id) settings forKey:(NSString*) key;

- (void)removeSettingsForKey:(NSString *)key;

- (BOOL)hasSettingForKey:(NSString *)key;

@end
