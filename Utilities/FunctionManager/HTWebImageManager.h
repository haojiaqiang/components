//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTObject.h"
#import <UIKit/UIKit.h>
#import "HTImageView.h"

@interface HTWebImageManager : HTObject


+ (HTWebImageManager *)sharedManager;

- (void)downloadImageWithURL:(NSString *)imageURL
                     options:(HTWebImageOptions)options
                    progress:(void(^)(NSInteger receivedSize, NSInteger expectedSize))progress
                  completion:(void(^)(UIImage *image, NSError *error, HTImageCacheType cacheType, BOOL finished, NSURL *imageURL)) completion;
@end
