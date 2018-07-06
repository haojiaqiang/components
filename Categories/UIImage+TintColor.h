//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到下
    GradientTypeLeftToRight = 1,//从左到右
};

@interface UIImage (TintColor)

- (UIImage *)tintedImageWithColor:(UIColor *)tintColor;

+ (UIImage *)imageWithView:(UIView*) view;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)getGradientImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;

@end
