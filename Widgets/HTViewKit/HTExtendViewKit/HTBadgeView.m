//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTBadgeView.h"
#import "HTLabel.h"

@implementation HTBadgeView
{
    HTLabel *_badgeLabel;
    CGFloat _badgeTextMargin;
}

- (void)loadSubviews {
    [super loadSubviews];
    
    self.userInteractionEnabled = NO;
    
    _badgeTextMargin = 2;
    
    _badgeLabel = [[HTLabel alloc] initWithFrame:CGRectInset(self.bounds, -1, -1)];
    _badgeLabel.font = [UIFont systemFontOfSize:10];
    _badgeLabel.textColor = [UIColor whiteColor];
    _badgeLabel.backgroundColor = [UIColor clearColor];
    _badgeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_badgeLabel];
    
    self.radius = self.height / 2;
    _badgeLabel.layer.cornerRadius = self.radius;
}

- (void)setBadgeColor:(UIColor *)badgeColor {
    self.backgroundColor = badgeColor;
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor {
    _badgeLabel.textColor = badgeTextColor;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _badgeLabel.layer.borderColor = borderColor.CGColor;
}

- (void)setBadgeFont:(UIFont *)badgeFont {
    _badgeLabel.font = badgeFont;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _badgeLabel.layer.borderWidth = borderWidth;
}

- (void)setBadgeText:(NSString *)badgeText {
    _badgeLabel.text = badgeText;
    [_badgeLabel sizeToFit];
    CGRect r = _badgeLabel.frame;
    r.size.height = self.height;
    r.size.width = MAX(self.height, r.size.width + _badgeTextMargin * 2);
    _badgeLabel.frame = r;
    
    self.width = _badgeLabel.width;
}

- (void)setBadgeStyle:(HTBadgeViewStyle)badgeStyle {
    _badgeStyle = badgeStyle;
    if (_badgeStyle == HTBadgeViewStyleDot) {
        _badgeLabel.text = @"";
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.radius = self.height / 2;
    _badgeLabel.frame = CGRectInset(self.bounds, -1, -1);
    _badgeLabel.layer.cornerRadius = _badgeLabel.height / 2;
}

- (void)show:(BOOL)show {
    self.hidden = !show;
}

- (void)show:(BOOL)show badgeText:(NSString *)badgeText {
    [self show:show];
    if (_badgeStyle == HTBadgeViewStyleText) {
        self.badgeText = badgeText;
    }
}

- (void)show:(BOOL)show badgeNumber:(NSInteger)badgeNumber {
    [self show:show badgeText:[NSString stringWithFormat:@"%ld", (long)badgeNumber]];
}

@end
