//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Device)

+ (UIImage *)ht_imagePNGWithDeferenceDevices:(NSString *)imageName;

+ (UIImage *)ht_imageJPGWithDeferenceDevices:(NSString *)imageName;

+ (UIImage *)ht_imagePNGWithContentsOfFileDeferenceDevice:(NSString *)imageName;

+ (UIImage *)ht_imageJPGWithContentsOfFileDeferenceDevice:(NSString *)imageName;
@end
