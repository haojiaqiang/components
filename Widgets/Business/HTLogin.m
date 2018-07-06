//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTLogin.h"
#import "HTLocalSettings.h"
#import "SAMKeychain.h"
#import "Constants.h"
#import "HTNotificationKeys.h"

#define HT_APP_USER_LOCAL_KEY @"_APP_USER_"

@implementation HTLogin

static HTLogin* _sharedInstance = nil;

+ (HTLogin*) sharedInstance
{
    @synchronized([HTLogin class])
    {
        if(!_sharedInstance)
            _sharedInstance = [[self alloc]init];
        return _sharedInstance;
    }
    return nil;
}

+ (instancetype)alloc
{
    @synchronized([HTLogin class])
    {
        NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedInstance = [super alloc];
        return _sharedInstance;
    }
    return nil;
}

- (BOOL) isGuest{
    return !self.user || (self.user.userId==0);
}

- (HTUser*) getUser{
    if(!_user){
        NSDictionary *dict = [[HTLocalSettings sharedSettings] getSettings:HT_APP_USER_LOCAL_KEY];
        if(dict){
            HTUser *user = [[HTUser alloc] initWithDictionary:dict];
            if(user){
                [self setUser:user];
            }
        }
    }
    return _user;
}

- (void) setUser:(HTUser *)user{
    _user = user;
    if(user){
        [[HTLocalSettings sharedSettings] setSettings:[user toDictionary] forKey:HT_APP_USER_LOCAL_KEY];
    }else{
        [[HTLocalSettings sharedSettings] removeSettingsForKey:HT_APP_USER_LOCAL_KEY];
    }
}

- (BOOL) isLogined:(HTUser *)user{
    return self.user && user && self.user.userId==user.userId;
}

- (void) logout{
    self.user = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOnLogout object:nil];
}

- (void) login:(HTUser *)user{
    [self login:user silently:NO];
}

- (void) login:(HTUser *)user silently:(BOOL)silently{
    [SAMKeychain setPassword:user.password forService:kAppName account:user.userName];
    user.password = nil;
    self.user = user;
    if (!silently) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOnLogin object:nil];
    }
}

- (void) login:(HTUser *)user withType:(HTLoginType)loginType{
    _loginType = loginType;
    [self login:user silently:NO];
}

@end
