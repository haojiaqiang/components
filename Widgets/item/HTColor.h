//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#define kC_fff391       kHRGB(0xfff391)
#define kC_f85800       kHRGB(0xf85800)
#define kC_333333       kHRGB(0x333333)
#define kC_999999       kHRGB(0x999999)
#define kC_666666       kHRGB(0x666666)
#define kC_ff8b00       kHRGB(0xff8b00)
#define kC_ff4e4e       kHRGB(0xff4e4e)
#define kC_3ea622       kHRGB(0x3ea622)
#define kC_f5f5f5       kHRGB(0xf5f5f5)
#define kC_cccccc       kHRGB(0xcccccc)
#define kC_ffc600       kHRGB(0xffc600)
#define kC_4e4e4e       kHRGB(0x4e4e4e)
#define kC_e4e4e4       kHRGB(0xe4e4e4)
#define kC_4081d6       kHRGB(0x4081d6)
#define kC_c4c4c4       kHRGB(0xc4c4c4)
#define kc_ffffff       kHRGB(0xffffff)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HTColor : NSObject

@property (nonatomic, assign) int red; // 0 ~ 255

@property (nonatomic, assign) int green; // 0 ~ 255

@property (nonatomic, assign) int blue; // 0 ~ 255

@property (nonatomic, assign) float alpha; // 0 ~ 1

- (UIColor *)color; // UIColor from EBColor

+ (HTColor *)color:(UIColor *)color;

+ (UIColor *)color:(int)red1 green1:(int)green1 blue1:(int)blue1 to:(int)red2 green2:(int)green2 blue2:(int)blue2 ratio:(float)ratio;

+ (UIColor *)color:(int)red1 green1:(int)green1 blue1:(int)blue1 to:(int)red2 green2:(int)green2 blue2:(int)blue2 opacity1:(float)opacity1 opacity2:(float)opacity2 ratio:(float)ratio;

+ (UIColor *)color:(HTColor *)color1 to:(HTColor *)color2 ratio:(float)ratio;

+ (UIColor *)uicolor:(UIColor *)color1 to:(UIColor *)color2 ratio:(float)ratio;


/**
 颜色定义
 */
+ (UIColor *)grayForDetailText;
+ (UIColor *)grayForTitleText;
+ (UIColor *)grayForIMTextBackground;
+ (UIColor *)whiteForTitleText;
+ (UIColor *)grayForUnableText;
+ (UIColor *)lightBlackForText;
+ (UIColor *)grayForLine;
+ (UIColor *)grayForSepratorLine;
+ (UIColor *)grayForDisable;
+ (UIColor *)grayForBackground;
+ (UIColor *)grayForBottomBackground;
+ (UIColor *)themeBlue;
+ (UIColor *)themeBlack;
+ (UIColor *)themeRed;
+ (UIColor *)themeGreen;
+ (UIColor *)themeOrange;

@end
