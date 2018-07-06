//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "UIViewController+UINavigationBar.h"
#import "HTBarButtonItem.h"
#import "NSString+Utilities.h"
#import "Constants.h"
#import "HTAppConstants.h"
#import "HTButton.h"
#import "HTColor.h"

@implementation UIViewController (UINavigationBar)

#pragma mark - Left

- (void)clearNavLeftItem {
    [self.navigationItem setLeftBarButtonItems:nil];
    [self.navigationItem setLeftBarButtonItem:nil];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)setNavLeftItemWithImage:(NSString *)image target:(id)target action:(SEL)action {
    // 左边按钮
    UIImage *img = [UIImage imageNamed:image];
    HTBarButtonItem *leftItem = [[HTBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:action];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}

- (void)setNavLeftItemWithName:(NSString *)name target:(id)target action:(SEL)action {
    [self setNavLeftItemWithName:name font:kAppAdaptFont(16) target:target action:action];
}

- (void)setNavLeftItemWithName:(NSString *)name font:(UIFont *)font target:(id)target action:(SEL)action {
    [self setNavLeftItemWithName:name font:font color:nil target:target action:action];
}

- (void)setNavLeftItemWithName:(NSString *)name font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action {
    NSString *leftTitle = name;
    UIFont *titleLabelFont = font;
    CGSize titleSize = [leftTitle returnSize:titleLabelFont MaxWidth:100];//一行宽度最大为 100 高度1000
    HTButton *btn = [HTButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = titleLabelFont;
    [btn setFrame:CGRectMake(0, 0, titleSize.width, self.navigationController.navigationBar.frame.size.height)];
    [btn setTitle:leftTitle forState:UIControlStateNormal];
    if (color) {
        [self setButton:btn titleColor:color];
    } else {
        [self setButton:btn titleColor:[HTColor themeBlack]];
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor clearColor]];
    HTBarButtonItem *leftItem = [[HTBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}

#pragma mark - Right

- (void)clearNavRightItem {
    [self.navigationItem setRightBarButtonItems:nil];
    [self.navigationItem setRightBarButtonItem:nil];
}

- (void)setNavRightItemWithImage:(NSString *)image target:(id)target action:(SEL)action {
    UIImage *img = [UIImage imageNamed:image];
    HTBarButtonItem *rightItem = [[HTBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:action];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)setNavRightItemWithName:(NSString *)name target:(id)target action:(SEL)action {
    [self setNavRightItemWithName:name font:kAppAdaptFont(16) target:target action:action];
}

- (void)setNavRightItemWithName:(NSString *)name font:(UIFont *)font target:(id)target action:(SEL)action {
    [self setNavRightItemWithName:name font:font color:nil target:target action:action];
}

- (void)setNavRightItemWithName:(NSString *)name font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action {
    // 右边按钮
    NSString *rightTitle = name;
    UIFont *titleLabelFont = font;
    CGSize titleSize = [name returnSize:titleLabelFont MaxWidth:100];//一行宽度最大为 100 高度1000
    HTButton *btn = [HTButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = titleLabelFont;
    [btn setFrame:CGRectMake(0, 0, titleSize.width, self.navigationController.navigationBar.frame.size.height)];
    [btn setTitle:rightTitle forState:UIControlStateNormal];
    if (color) {
        [self setButton:btn titleColor:color];
    } else {
        [self setButton:btn titleColor:[HTColor themeBlack]];
    }
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor clearColor]];

    [self setNavRightItemWithButton:btn];
}

- (void)setNavRightItemWithButton:(UIButton *)btn {
    HTBarButtonItem *rightItem = [[HTBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:rightItem animated:NO];
}

#pragma mark - Tool

- (void)setButton:(UIButton *)button titleColor:(UIColor *)color {
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateHighlighted];
    [button setTitleColor:color forState:UIControlStateSelected];
}

@end
