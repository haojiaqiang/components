//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTView.h"
#import "HTColor.h"

@implementation HTView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame andRadius:0];
}

- (instancetype)initWithFrame:(CGRect)frame andRadius:(CGFloat)radius {
    self = [super initWithFrame:frame];
    if (self) {
        [self initRadius:radius];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self loadSubviews];
    }
    return self;
}

- (void)loadSubviews {
    
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    if ([self hasRadius] && _backgroundColor && _backgroundColor != [UIColor clearColor]) {
        [super setBackgroundColor:[UIColor clearColor]];
        [self setNeedsDisplay];
    }
    else {
        if (backgroundColor) {
            [super setBackgroundColor:backgroundColor];
        }
        else {
            [super setBackgroundColor:[UIColor clearColor]];
        }
    }
}

- (UIColor*)backgroundColor {
    if (_backgroundColor) {
        return _backgroundColor;
    }
    return [super backgroundColor];
}

- (BOOL)hasRadius {
    return _ltRadius > 0 || _rtRadius > 0 || _lbRadius > 0 || _rbRadius > 0;
}

- (void)initRadius:(CGFloat)radius {
    _radius = radius;
    _ltRadius = radius;
    _rtRadius = radius;
    _lbRadius = radius;
    _rbRadius = radius;
}

- (void)setLtRadius:(CGFloat)ltRadius {
    if (_ltRadius != ltRadius) {
        _ltRadius = ltRadius;
        [self setBackgroundColor:_backgroundColor];
    }
}

- (CGFloat)ltRadius {
    return _ltRadius;
}

- (void)setRtRadius:(CGFloat)rtRadius {
    if (_rtRadius != rtRadius) {
        _rtRadius = rtRadius;
        [self setBackgroundColor:_backgroundColor];
    }
}

- (CGFloat)rtRadius {
    return _rtRadius;
}

- (void)setLbRadius:(CGFloat)lbRadius {
    if (_lbRadius != lbRadius) {
        _lbRadius = lbRadius;
        [self setBackgroundColor:_backgroundColor];
    }
}

- (CGFloat)lbRadius {
    return _lbRadius;
}

- (void)setRbRadius:(CGFloat)rbRadius {
    if (_rbRadius != rbRadius) {
        _rbRadius = rbRadius;
        [self setBackgroundColor:_backgroundColor];
    }
}

- (CGFloat)rbRadius {
    return _rbRadius;
}

- (void)setRadius:(CGFloat)radius {
    if (_radius != radius) {
        [self initRadius:radius];
    }
    [self setBackgroundColor:_backgroundColor];
}

- (CGFloat)getRadius {
    return _radius;
}

- (void)setFrame:(CGRect)frame {
//    /// Wrapper frame
//    frame.size.width = ((int)(frame.size.width * 2)) / 2.0f;
//    frame.size.height = ((int)(frame.size.height * 2)) / 2.0f;
//    frame.origin.x = ((int)(frame.origin.x * 2)) / 2.0f;
//    frame.origin.y = ((int)(frame.origin.y * 2)) / 2.0f;
    [super setFrame:frame];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    UIColor *backgroundColor = _backgroundColor;
    
    if ([self hasRadius] && backgroundColor) {
        // get the contect
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // the rest is pretty much copied from Apples example
        CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
        CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
        
        // Start at 1
        CGContextMoveToPoint(context, minx, midy);
        // Add an arc through 2 to 3
        CGContextAddArcToPoint(context, minx, miny, midx, miny, _ltRadius);
        // Add an arc through 4 to 5
        CGContextAddArcToPoint(context, maxx, miny, maxx, midy, _rtRadius);
        // Add an arc through 6 to 7
        CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, _rbRadius);
        // Add an arc through 8 to 9
        CGContextAddArcToPoint(context, minx, maxy, minx, midy, _lbRadius);
        // Close the path
        CGContextClosePath(context);
        
        //CGContextSetRGBFillColor(context, 1.0, 0.0, 1.0, 1.0);
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        
        // Fill & stroke the path
        CGContextDrawPath(context, kCGPathFill);
    }
}

+ (HTView *)createLineWithFrame:(CGRect)frame{
    
    HTView * line = [[HTView alloc]initWithFrame:frame];
    line.backgroundColor = [HTColor grayForLine];
    return line;
}

@end

@implementation UIView (Frame)

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)newX {
    CGRect frame = self.frame;
    frame.origin.x = newX;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)newY {
    CGRect frame = self.frame;
    frame.origin.y = newY;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newWidth {
    CGRect frame = self.frame;
    frame.size.width = newWidth;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newHeight {
    CGRect frame = self.frame;
    frame.size.height = newHeight;
    self.frame = frame;
}

- (CGFloat)maxY {
    return self.y + self.height;
}

- (void)setMaxY:(CGFloat)maxY {
    [self setY:maxY - self.height];
}

- (CGFloat)maxX {
    return self.x + self.width;
}

- (void)setMaxX:(CGFloat)maxX {
    [self setX:maxX - self.width];
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect r = self.frame;
    r.origin = origin;
    self.frame = r;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect r = self.frame;
    r.size = size;
    self.frame = r;
}

@end
