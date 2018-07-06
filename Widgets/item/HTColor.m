//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTColor.h"
#import "Constants.h"

@implementation HTColor

- (void)setRed:(int)red {
    _red = MAX(0, MIN(red, 255));
}

- (void)setGreen:(int)green {
    _green = MAX(0, MIN(green, 255));
}

- (void)setBlue:(int)blue {
    _blue = MAX(0, MIN(blue, 255));
}

- (void)setAlpha:(float)alpha {
    _alpha = MAX(0, MIN(alpha, 1.0));
}

- (UIColor *)color {
    return kRGBA(_red, _green, _blue, _alpha);
}

+ (HTColor *)color:(UIColor *)color {
    HTColor *c = [[HTColor alloc] init];
    const CGFloat* components = CGColorGetComponents(color.CGColor);
    c.red = (int)(components[0] * 255);
    c.green = (int)(components[1] * 255);
    c.blue = (int)(components[2] * 255);
    return c;
}

+ (UIColor *)color:(int)red1 green1:(int)green1 blue1:(int)blue1 to:(int)red2 green2:(int)green2 blue2:(int)blue2 ratio:(float)ratio {
    return [self color:red1 green1:green1 blue1:blue1 to:red2 green2:green2 blue2:blue2 opacity1:1.0 opacity2:1.0 ratio:ratio];
}

+ (UIColor *)color:(int)red1 green1:(int)green1 blue1:(int)blue1 to:(int)red2 green2:(int)green2 blue2:(int)blue2 opacity1:(float)opacity1 opacity2:(float)opacity2 ratio:(float)ratio {
    return kRGBA((int)(red1 + (red2 - red1) * ratio), (int)(green1 + (green2 - green1) * ratio), (int)(blue1 + (blue2 - blue1) * ratio), opacity1 + (opacity2 - opacity1) * ratio);
}

+ (UIColor *)color:(HTColor *)color1 to:(HTColor *)color2 ratio:(float)ratio {
    return [self color:color1.red green1:color1.green blue1:color1.blue to:color2.red green2:color2.green blue2:color2.blue ratio:ratio];
}

+ (UIColor *)uicolor:(UIColor *)color1 to:(UIColor *)color2 ratio:(float)ratio {
    return [self color:[HTColor color:color1] to:[HTColor color:color2] ratio:ratio];
}

+ (UIColor *)grayForDetailText {
    return kHRGB(0x7c7c7c);
}

+ (UIColor *)grayForTitleText {
    return kHRGB(0x000000);
}

+ (UIColor *)grayForIMTextBackground {
    return kHRGB(0xC4C4C4);
}

+ (UIColor *)whiteForTitleText {
    return kHRGB(0xffffff);
}

+ (UIColor *)grayForUnableText {
    return kHRGB(0x999999);
}

+ (UIColor *)grayForLine {
    return kHRGB(0xe4e4e4);
}

+ (UIColor *)grayForSepratorLine {
    return kHRGB(0xD7D7D7);
}

+ (UIColor *)grayForDisable {
    return kHRGB(0xD8D8D8);
}

+ (UIColor *)grayForBackground {
    return kHRGB(0xf0f0f0);
}

+ (UIColor *)grayForBottomBackground {
    return kHRGB(0xf5f5f5);
}

+ (UIColor *)themeBlue {
    return kHRGB(0x4081D6);
}

+ (UIColor *)themeBlack {
    return kHRGB(0x000000);
}

+ (UIColor *)themeRed {
    return kHRGB(0xFC4C5A);
}

+ (UIColor *)themeGreen {
    return kHRGB(0x49C72A);
}

+ (UIColor *)themeOrange {
    return kHRGB(0xF7A760);
}

+ (UIColor *)lightBlackForText {
    return kHRGB(0x4e4e4e);
}

@end
