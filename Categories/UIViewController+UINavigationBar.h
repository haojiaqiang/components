//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UINavigationBar)

- (void)clearNavLeftItem;
- (void)setNavLeftItemWithImage:(NSString *)image target:(id)target action:(SEL)action;
- (void)setNavLeftItemWithName:(NSString *)name target:(id)target action:(SEL)action;
- (void)setNavLeftItemWithName:(NSString *)name font:(UIFont *)font target:(id)target action:(SEL)action;
- (void)setNavLeftItemWithName:(NSString *)name font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action;

- (void)clearNavRightItem;
- (void)setNavRightItemWithImage:(NSString *)image target:(id)target action:(SEL)action;
- (void)setNavRightItemWithName:(NSString *)name target:(id)target action:(SEL)action;
- (void)setNavRightItemWithName:(NSString *)name font:(UIFont *)font target:(id)target action:(SEL)action;
- (void)setNavRightItemWithName:(NSString *)name font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action;

@end
