//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIkit.h>

#define kAppStatusBarHeight ([UIUtility statusHeight])
#define kAppNavigationBarHeight ([UIUtility navigationBarHeight])
#define kAppSafeAreaTopMargin ([UIUtility safeAreaTopMargin])
#define kAppSafeAreaBottomMargin ([UIUtility safeAreaBottomMargin])
#define kAppCurvedScreenBottomMargin ([UIUtility safeAreaBottomMargin] - [UIUtility tabBarHeight]) //iPhoneX下方多出来的高度，固定数值34，非iPhone X为0
#define kAppTabBarHeight ([UIUtility tabBarHeight])

@interface UIUtility : NSObject

/**
 * 将view的边角磨圆
 */
+ (void)view:(UIView *)view withRadius:(CGFloat)radius;

/**
 *  设置Button风格
 */
+ (void)setButtonStyle:(UIButton *)btn andColor:(UIColor *)color;

+ (void)setButtonStyleBackgroundColor:(UIButton *)btn andColor:(UIColor *)color;

/**
 * 状态栏高度
 */
+ (CGFloat)statusHeight;

/**
 * 导航栏高度
 */
+ (CGFloat)navigationBarHeight;

/**
 * 状态栏高度 + 导航栏高度
 */
+ (CGFloat)safeAreaTopMargin;

/**
 * tabbar高度
 */
+ (CGFloat)tabBarHeight;

/**
 * tabbar高度 + 下边界高度（iPhone X才有）
 */
+ (CGFloat)safeAreaBottomMargin;

/**
 * 键盘高度
 */
+ (CGFloat)keyboardHeightFromNotificationUserInfo:(NSDictionary *)userInfo;

/**
 * 屏幕高度
 */
+ (CGFloat)screenHeight;

/**
 * 屏幕宽度
 */
+ (CGFloat)screenWidth;

@end
