//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTUser.h"

typedef enum{
    HTLoginTypeDiretory = 0,
    HTLoginTypeWhenRequired = 1,
}HTLoginType;

@interface HTLogin : NSObject
{
    HTUser *_user;
    HTLoginType _loginType;
}
+ (HTLogin*) sharedInstance;
@property (nonatomic, assign, readonly, getter=isGuest) BOOL guest;
@property (nonatomic, strong, setter=setUser:, getter=getUser) HTUser *user;
@property (nonatomic, assign, readonly) HTLoginType loginType;

- (BOOL) isLogined:(HTUser*) user;
- (void) logout;
- (void) login:(HTUser*) user;
- (void) login:(HTUser*) user withType:(HTLoginType) loginType;
- (void) login:(HTUser*) user silently:(BOOL) silently;

@end
