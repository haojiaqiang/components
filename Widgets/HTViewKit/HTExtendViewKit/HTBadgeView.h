//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTView.h"

typedef NS_ENUM(NSInteger, HTBadgeViewStyle) {
    HTBadgeViewStyleText,
    HTBadgeViewStyleDot,
};

@interface HTBadgeView : HTView

@property (nonatomic, assign) HTBadgeViewStyle badgeStyle;

@property (nonatomic, strong) UIColor *badgeColor;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, strong) UIColor *badgeTextColor;

@property (nonatomic, strong) UIFont *badgeFont;

@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, strong) NSString *badgeText;

@property (nonatomic, assign) CGFloat badgeTextMargin; // Default 2 pixel,

- (void)show:(BOOL)show;

- (void)show:(BOOL)show badgeText:(NSString *)badgeText;

- (void)show:(BOOL)show badgeNumber:(NSInteger)badgeNumber;

@end
