//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "LFNetworkManager.h"
#import "HTNetworkManager.h"
#import "HTResponse.h"
#import "HTRequest.h"
#import "HTNotificationKeys.h"

@implementation LFNetworkManager

static LFNetworkManager *_sharedInstance;

+ (LFNetworkManager *)sharedManager {
    @synchronized ([LFNetworkManager class]) {
        if (!_sharedInstance) {
            _sharedInstance = [[self alloc] init];
        }
        return _sharedInstance;
    }
    return nil;
}

+ (instancetype)alloc {
    @synchronized ([LFNetworkManager class]) {
        NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedInstance = [super alloc];
        return _sharedInstance;
    }
    return nil;
}

- (void)post:(HTRequest *)request forResponseClass:(Class)clazz success:(void (^)(HTResponse *response))success failure:(void (^)(NSError *error))failure {
    [self post:request forResponseClass:clazz success:success failure:failure inViewController:nil];
}

- (void)post:(HTRequest *)request forResponseClass:(Class)clazz success:(void (^)(HTResponse *response))success failure:(void (^)(NSError *error))failure inViewController:(UIViewController *)viewController {
    [[HTNetworkManager sharedManager] post:request forResponseClass:clazz success:^(HTResponse *response) {
        if (response && [response isKindOfClass:[HTResponse class]]) {
            if (((HTResponse *)response).status == -1) {
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:response.dictionary];
                [dictionary setObject:NSStringFromClass(response.class) forKey:@"target"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReLoginRequired object:dictionary];
                [self stopLoadingViewInViewController:viewController];
                return;
            }
            else if (((HTResponse *)response).status == -10) {
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:response.dictionary];
                [dictionary setObject:NSStringFromClass(response.class) forKey:@"target"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForceLogout object:dictionary];
                [self stopLoadingViewInViewController:viewController];
                return;
            }
            else if (((HTResponse *)response).status == -100) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationServerMaintance object:response.dictionary];
                [self stopLoadingViewInViewController:viewController];
                return;
            }
        }
        if (success) {
            success(response);
        }
    } failure:failure];
}

- (void)stopLoadingViewInViewController:(UIViewController *)viewController {
//TO-DO Hayato
}

@end
