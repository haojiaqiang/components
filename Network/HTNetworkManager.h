//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTRequest, HTResponse;

@interface HTNetworkManager : NSObject

+ (HTNetworkManager *)sharedManager;

- (void)get:(HTRequest *)request forResponseClass:(Class)clazz
    success:(void (^)(HTResponse *response))success
    failure:(void (^)(NSError *error))failure;

- (void)post:(HTRequest *)request forResponseClass:(Class)clazz
     success:(void (^)(HTResponse *response))success
     failure:(void (^)(NSError *error))failure;

- (void)get:(HTRequest *)request forResponseClass:(Class)clazz
   progress:(void (^)(NSProgress *downloadProgress))progress
    success:(void (^)(HTResponse *response))success
    failure:(void (^)(NSError *error))failure;

- (void)post:(HTRequest *)request forResponseClass:(Class)clazz
    progress:(void (^)(NSProgress *uploadProgress))progress
     success:(void (^)(HTResponse *response))success
     failure:(void (^)(NSError *error))failure;

- (void)abort:(NSString *)url;

@end
