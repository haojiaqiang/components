//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTWebImageManager.h"

@implementation HTWebImageManager

static HTWebImageManager *_sharedInstance = nil;

+ (HTWebImageManager *)sharedManager {
    @synchronized([HTWebImageManager class]) {
        if(!_sharedInstance)
            _sharedInstance = [[self alloc] init];
        return _sharedInstance;
    }
    return nil;
}

+ (id)alloc {
    @synchronized([HTWebImageManager class]) {
        NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedInstance = [super alloc];
        return _sharedInstance;
    }
    return nil;
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
