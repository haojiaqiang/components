//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIView (ConvenienceFrame)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

@property (nonatomic, retain) UIColor *borderColor;

@property (nonatomic, readonly) UIViewController *viewController;

- (void)centerInSuperView;
- (void)aestheticCenterInSuperView;

- (UIImage *)imageForView;

//根据添加的约束计算高度
- (CGFloat)heightByAutoLayoutWithWidth:(CGFloat)width;

@end
