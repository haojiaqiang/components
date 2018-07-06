//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

typedef NS_ENUM(NSInteger, HTWebImageOptions) {
    //if download error, try again
    HTWebImageOptionsRetryFailed = SDWebImageRetryFailed,
    
    //when scrollView is scroll, delay download
    HTWebImageOptionsLowPriority = SDWebImageLowPriority,
    
    //cache memory only
    HTWebImageOptionsCacheMemoryOnly = SDWebImageCacheMemoryOnly,
    
    //progressive download
    HTWebImageOptionsProgressiveDownload = SDWebImageProgressiveDownload,
    
    //cache disk, NSURLCache will deal
    HTWebImageOptionsRefreshCached = SDWebImageRefreshCached,
};

typedef NS_ENUM(NSInteger, HTImageCacheType) {
    HTImageCacheTypeNone = SDImageCacheTypeNone,
    HTImageCacheTypeDisk = SDImageCacheTypeDisk,
    HTImageCacheTypeMemory = SDImageCacheTypeMemory,
};

@interface HTImageView : UIImageView
//- (void)wifiDownloadImage_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completedBlock;
@end

@interface UIImageView (HTKit)


/**
 设置头像专用
 */
- (void)setHeadImageWith:(NSString *)url;

- (void)setImageWithURL:(NSString *)url;

- (void)setImageWithURL:(NSString *)url
       placeholderImage:(UIImage *)placeholderImage;

- (void)setImageWithURL:(NSString *)url
             completion:(void(^)(UIImage *image, NSError *error, HTImageCacheType cacheType, NSURL *imageURL)) completion;

- (void)setImageWithURL:(NSString *)url
       placeholderImage:(UIImage *)placeholderImage
                options:(HTWebImageOptions)options;

- (void)setImageWithURL:(NSString *)url
       placeholderImage:(UIImage *)placeholderImage
             completion:(void(^)(UIImage *image, NSError *error, HTImageCacheType cacheType, NSURL *imageURL)) completion;

- (void)setImageWithURL:(NSString *)url
                options:(HTWebImageOptions)options
       placeholderImage:(UIImage *)placeholderImage
             completion:(void(^)(UIImage *image, NSError *error, HTImageCacheType cacheType, NSURL *imageURL)) completion;

- (void)setImageWithURL:(NSString *)url
       placeholderImage:(UIImage *)placeholderImage
                options:(HTWebImageOptions)options
               progress:(void(^)(NSInteger receivedSize, NSInteger expectedSize))progress
             completion:(void(^)(UIImage *image, NSError *error, HTImageCacheType cacheType, NSURL *imageURL)) completion;

@end
