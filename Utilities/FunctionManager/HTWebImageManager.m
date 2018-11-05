//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTWebImageManager.h"

@implementation HTWebImageManager

static HTWebImageManager *_sharedInstance = nil;

+ (instancetype)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

+ (instancetype)sharedManager {
    return [[self alloc] init];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (void)downloadImageWithURL:(NSString *)imageURL
                     options:(HTWebImageOptions)options
                    progress:(void(^)(NSInteger receivedSize, NSInteger expectedSize))progress
                  completion:(void(^)(UIImage *image, NSError *error, HTImageCacheType cacheType, BOOL finished, NSURL *imageURL)) completion {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager loadImageWithURL:[NSURL URLWithString:imageURL]
                      options:(SDWebImageOptions)options
                     progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                         if (progress) {
                             progress(receivedSize, expectedSize);
                         }
                     } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                         if (completion) {
                             completion(image, error, (HTImageCacheType)cacheType, finished, imageURL);
                         }
                     }];
}

@end
