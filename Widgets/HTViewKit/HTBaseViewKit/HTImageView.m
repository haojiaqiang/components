//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTImageView.h"
#import "HTNetworkReachabilityManager.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "NSString+Utilities.h"

@implementation HTImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//- (void)wifiDownloadImage_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completedBlock{
//    if ([[[TWLocalSettings sharedSettings] getSettings:kOnlyWifiDownloadImage] boolValue]){
//        if ([HTNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
//            [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
//        }else{
//            NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
//            UIImage * image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
//            if (image) {
//                self.image = image;
//                completedBlock(image,nil,SDImageCacheTypeMemory,url);
//                return;
//            }else{
//                image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
//            }
//            if (image) {
//                self.image = image;
//                completedBlock(image,nil,SDImageCacheTypeDisk,url);
//            }else{
//                UIImage * image = [UIImage imageNamed:@"list-house-failed-icon"];
//                self.image = image;
//                completedBlock(image,nil,SDImageCacheTypeNone,url);
//            }
//        }
//        
//    }else{
//        [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
//    }
//}
@end

@implementation UIImageView (TWKit)

- (void)setHeadImageWith:(NSString *)url {
    [self setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user-default"]];
}

- (void)setImageWithURL:(NSString *)url {
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage {
    [self setImageWithURL:url placeholderImage:placeholderImage options:HTWebImageOptionsRetryFailed];
}

- (void)setImageWithURL:(NSString *)url completion:(void(^)(UIImage *image, NSError *error, HTImageCacheType cacheType, NSURL *imageURL)) completion {
    [self setImageWithURL:url placeholderImage:nil completion:completion];
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage options:(HTWebImageOptions)options {
    [self setImageWithURL:url options:options placeholderImage:placeholderImage completion:nil];
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage completion:(void(^)(UIImage *image, NSError *error, HTImageCacheType cacheType, NSURL *imageURL)) completion {
    [self setImageWithURL:url placeholderImage:placeholderImage options:HTWebImageOptionsRetryFailed progress:nil completion:completion];
}

- (void)setImageWithURL:(NSString *)url options:(HTWebImageOptions)options placeholderImage:(UIImage *)placeholderImage completion:(void(^)(UIImage *image, NSError *error, HTImageCacheType cacheType, NSURL *imageURL)) completion {
    [self setImageWithURL:url placeholderImage:placeholderImage options:options progress:nil completion:completion];
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage options:(HTWebImageOptions)options progress:(void(^)(NSInteger receivedSize, NSInteger expectedSize))progress completion:(void(^)(UIImage *image, NSError *error, HTImageCacheType cacheType, NSURL *imageURL)) completion {
    if (![NSString isNullOrEmpty:url]) {
        [self sd_setImageWithURL:[NSURL URLWithString:url]
                placeholderImage:placeholderImage
                         options:(SDWebImageOptions)options
                        progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                            if (progress) {
                                progress(receivedSize, expectedSize);
                            }
                        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                            if (completion) {
                                completion(image, error, (HTImageCacheType)cacheType, imageURL);
                            }
                        }];
    }
    else {
        self.image = placeholderImage;
    }
}

@end
