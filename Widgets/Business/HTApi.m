//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTApi.h"

@implementation HTApi

+ (NSString*) getApi:(NSString *)apiName {
#if defined(APP_DEBUG) || defined(APP_BETA)
    NSString *protocal = [[TWLocalSettings sharedSettings] getSettings:@"SVR_PROTOCAL"];
    NSString *ip = [[TWLocalSettings sharedSettings] getSettings:@"SVR_IP"];
    NSString *port = [[TWLocalSettings sharedSettings] getSettings:@"SVR_PORT"];
    NSString *path = [[TWLocalSettings sharedSettings] getSettings:@"SVR_PATH"];
    if (![NSString isNullOrEmpty:ip] && ![NSString isNullOrEmpty:port]) {
        return [NSString stringWithFormat:@"%@://%@:%@/%@%@", protocal, ip, port, path, apiName];
    }
#endif
    return @"";//kAppApi(apiName);
}

@end
