//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//


#import "UIUtility.h"
#import "HTDeviceUtilities.h"

@implementation UIUtility

+ (void)view:(UIView *)view withRadius:(CGFloat)radius {
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}

+ (CGFloat)statusHeight {
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    return rectStatus.size.height;
}

+ (CGFloat)navigationBarHeight {
    static UINavigationController *vc;
    if (!vc) {
        vc =[UINavigationController new];
    }
    CGRect rectNav = [vc.navigationBar frame];
    return rectNav.size.height;
}

+ (CGFloat)tabBarHeight {
    static UITabBarController *vc;
    if (!vc) {
        vc =[UITabBarController new];
    }
    CGRect rectTab = [vc.tabBar frame];
    return rectTab.size.height;
}

+ (CGFloat)safeAreaTopMargin {
    return [self statusHeight]+[self navigationBarHeight];
}

+ (CGFloat)safeAreaBottomMargin {
    if ([[HTDeviceUtilities sharedInstance] iPhoneX]) {
        return [self tabBarHeight] + 34;
    } else {
        return [self tabBarHeight];
    }
}

+ (CGFloat)keyboardHeightFromNotificationUserInfo:(NSDictionary *)userInfo {
    CGFloat currentKeyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= 80000))
    //以下代码主要是为了让iOS8SDK＋iOS8之后的设备得到的键盘尺寸与iOS8SDK之前的计算方法保持一致
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)
        && UIDeviceOrientationIsLandscape((UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation)) {
        currentKeyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.width;
    }
#endif
    
    return currentKeyboardHeight;
}

+ (CGFloat)screenWidth {
    return MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

+ (CGFloat)screenHeight {
    return MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

+ (void)setButtonStyle:(UIButton *)btn andColor:(UIColor *)color{
    btn.layer.cornerRadius = 4.0;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = color.CGColor;
    btn.layer.borderWidth = 1;
    [btn setTitleColor:color forState:UIControlStateNormal];
}

+ (void)setButtonStyleBackgroundColor:(UIButton *)btn andColor:(UIColor *)color {
    btn.layer.cornerRadius = 4.0;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
}

@end
