//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HTResponse, HTRequest;

@interface LFNetworkManager : NSObject

+ (LFNetworkManager *)sharedManager;

- (void)post:(HTRequest *)request forResponseClass:(Class)clazz success:(void (^)(HTResponse *response))success failure:(void (^)(NSError *error))failure;
- (void)post:(HTRequest *)request forResponseClass:(Class)clazz success:(void (^)(HTResponse *response))success failure:(void (^)(NSError *error))failure inViewController:(UIViewController *)viewController;

@end
