//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "UIImage+Device.h"
#import "HTDeviceUtilities.h"

@implementation UIImage (Device)

+ (UIImage *)ht_imagePNGWithDeferenceDevices:(NSString *)imageName {
    return [self ht_imageWithDeferenceDevice:imageName type:@"png"];
}

+ (UIImage *)ht_imageJPGWithDeferenceDevices:(NSString *)imageName {
    return [self ht_imageWithDeferenceDevice:imageName type:@"jpg"];
}

+ (UIImage *)ht_imageWithDeferenceDevice:(NSString *)imageName type:(NSString *)type {
    NSString *newName = nil;
    if ([[HTDeviceUtilities sharedInstance] iPhone4]) {
        newName = [NSString stringWithFormat:@"%@-4s.%@", imageName, type];
    }
    else if ([[HTDeviceUtilities sharedInstance] iPhone5]) {
        newName = [NSString stringWithFormat:@"%@-5s.%@", imageName, type];
    }
    else if ([[HTDeviceUtilities sharedInstance] iPhone6]) {
        newName = [NSString stringWithFormat:@"%@-6s.%@", imageName, type];
    }
    else if ([[HTDeviceUtilities sharedInstance] iPhonePlus]) {
        newName = [NSString stringWithFormat:@"%@-6p.%@", imageName, type];
    }
    else if ([[HTDeviceUtilities sharedInstance] iPhoneX]) {
        newName = [NSString stringWithFormat:@"%@-x.%@", imageName, type];
    }
    return [UIImage imageNamed:newName];
}

#pragma mark - imageWithContentsOfFile -
+ (UIImage *)ht_imagePNGWithContentsOfFileDeferenceDevice:(NSString *)imageName {
    return [self ht_imageWithContentsOfFileDeferenceDevice:imageName type:@"png"];
}

+ (UIImage *)ht_imageJPGWithContentsOfFileDeferenceDevice:(NSString *)imageName {
    return [self ht_imageWithContentsOfFileDeferenceDevice:imageName type:@"jpg"];
}

+ (UIImage *)ht_imageWithContentsOfFileDeferenceDevice:(NSString *)imageName type:(NSString *)type {
    NSString *fileName = nil;
    if ([[HTDeviceUtilities sharedInstance] iPhone4]) {
        fileName = [NSString stringWithFormat:@"iPhone4s-%@", imageName];
    }
    else if ([[HTDeviceUtilities sharedInstance] iPhone5]) {
        fileName = [NSString stringWithFormat:@"iPhone5s-%@", imageName];
    }
    else if ([[HTDeviceUtilities sharedInstance] iPhone6]) {
        fileName = [NSString stringWithFormat:@"iPhone6s-%@", imageName];
    }
    else if ([[HTDeviceUtilities sharedInstance] iPhonePlus]) {
        fileName = [NSString stringWithFormat:@"iPhonePlus-%@", imageName];
    }
    else if ([[HTDeviceUtilities sharedInstance] iPhoneX]) {
        fileName = [NSString stringWithFormat:@"iPhoneX-%@", imageName];
    }
    NSString *filePath = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] pathForResource:fileName ofType:type]];
    return [UIImage imageWithContentsOfFile:filePath];
}

@end
