//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTView : UIView
{
    UIColor *_backgroundColor;
    
    CGFloat _radius;
    CGFloat _ltRadius;
    CGFloat _rtRadius;
    CGFloat _lbRadius;
    CGFloat _rbRadius;
}
@property (nonatomic, assign) CGFloat radius;   // Radius
@property (nonatomic, assign) CGFloat ltRadius; // Left Top Radius
@property (nonatomic, assign) CGFloat rtRadius; // Right Top Radius
@property (nonatomic, assign) CGFloat lbRadius; // Left Bottom Radius
@property (nonatomic, assign) CGFloat rbRadius; // Right Bottom Radius

- (instancetype)initWithFrame:(CGRect)frame andRadius:(CGFloat)radius;

- (void)loadSubviews;

+ (HTView *)createLineWithFrame:(CGRect)frame;

@end

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat maxY;

@property (nonatomic, assign) CGFloat maxX;

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGSize size;

@end
