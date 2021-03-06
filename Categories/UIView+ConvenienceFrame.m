//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "UIView+ConvenienceFrame.h"

@implementation UIView (ConvenienceFrame)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderWidth = 1;
    self.layer.borderColor = [borderColor CGColor];
}

- (void)centerInSuperView {
    if (self.superview) {
        CGFloat xPos = roundf((self.superview.frame.size.width - self.frame.size.width) / 2.f);
        CGFloat yPos = roundf((self.superview.frame.size.height - self.frame.size.height) / 2.f);
        [self setOrigin:CGPointMake(xPos, yPos)];
    }
}

- (void)aestheticCenterInSuperView {
    if (self.superview) {
        CGFloat xPos = roundf(([self.superview width] - [self width]) / 2.0);
        CGFloat yPos = roundf(([self.superview height] - [self height]) / 2.0) - ([self.superview height] / 8.0);
        [self setOrigin:CGPointMake(xPos, yPos)];
    }
}

- (void)makeMarginInSuperViewWithTopMargin:(CGFloat)topMargin leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin andBottomMargin:(CGFloat)bottomMargin {
    if (self.superview) {
        CGRect r = self.superview.bounds;
        r.origin.x = leftMargin;
        r.origin.y = topMargin;
        r.size.width -= (leftMargin + rightMargin);
        r.size.height -= (topMargin + bottomMargin);
        [self setFrame:r];
    }
}

- (void)makeMarginInSuperViewWithTopMargin:(CGFloat)topMargin andSideMargin:(CGFloat)sideMargin {
    if (self.superview) {
        [self makeMarginInSuperViewWithTopMargin:topMargin leftMargin:sideMargin rightMargin:sideMargin andBottomMargin:topMargin];
    }
}

- (void)makeMarginInSuperView:(CGFloat)margin {
    if (self.superview) {
        [self makeMarginInSuperViewWithTopMargin:margin andSideMargin:margin];
    }
}

- (UIImage *)imageForView {
    CGSize size = self.frame.size;
    UIGraphicsBeginImageContext(size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIViewController *)viewController {
    for (UIView *next = self; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

-(CGFloat)heightByAutoLayoutWithWidth:(CGFloat)width{
    NSMutableArray* oldFrameConstraintArray = [NSMutableArray new];
    for (NSLayoutConstraint* constraint in self.constraints) {
        if (constraint.firstItem == self && (constraint.firstAttribute == NSLayoutAttributeWidth || constraint.firstAttribute == NSLayoutAttributeHeight)) {
            [oldFrameConstraintArray addObject:constraint];
        }
    }
    
    for (NSLayoutConstraint* constraint in oldFrameConstraintArray) {
        [self removeConstraint:constraint];
    }
    
    NSLayoutConstraint *newWidthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];
    [self addConstraint:newWidthConstraint];
    
    
    // Auto layout engine does its math
    CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    
    [self removeConstraint:newWidthConstraint];
    
    for (NSLayoutConstraint* constraint in oldFrameConstraintArray) {
        [self addConstraint:constraint];
    }
    
    return height;
}

@end
