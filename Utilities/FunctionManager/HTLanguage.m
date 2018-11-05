//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTLanguage.h"
#import "HTLocalSettings.h"
#import "NSString+Utilities.h"
#import "HTLocalSettings.h"

@implementation HTLanguage

static HTLanguage* _sharedInstance = nil;

+ (instancetype)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (void) setLanguage:(NSString *)language{
    if([NSString isNullOrEmpty:language]){
        return;
    }
    NSString *currentLanguage = [self getLanguage];
    if(![language isEqualToString:currentLanguage]){
        static NSString *appleLanguagesKey = @"AppleLanguages";
        NSMutableArray *appleLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:appleLanguagesKey];
        if([appleLanguages containsObject:language] && ![language isEqualToString:[appleLanguages objectAtIndex:0]]){
            [[NSUserDefaults standardUserDefaults] setObject:language forKey:HT_CUSTOME_LANGUAGE_KEY];
            [appleLanguages removeObject:language];
            [appleLanguages insertObject:language atIndex:0];
            [[NSUserDefaults standardUserDefaults] setObject:appleLanguages forKey:appleLanguagesKey];
            [[NSUserDefaults standardUserDefaults] synchronize]; //to make the change immediate
        }
    }
}

- (NSString*) getLanguage{
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:HT_CUSTOME_LANGUAGE_KEY];
    if(!language){
        static NSString *appleLanguagesKey = @"AppleLanguages";
        NSMutableArray *appleLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:appleLanguagesKey];
        if(appleLanguages && appleLanguages.count>0){
            language = [appleLanguages objectAtIndex:0];
        }
    }
    return language;
}

- (NSArray*) availableLanguages{
    return [NSArray arrayWithObjects:@"zh-Hans", @"en", @"zh-Hant", nil];
}

@end
