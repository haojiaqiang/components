//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTGradientView.h"

@implementation HTGradientView
{
    CAGradientLayer *_gradientLayer;
}

- (void) setColors:(NSArray *)colors {
    _colors = colors;
    [self refreshGradient];
}

- (void) refreshGradient{
    if (!_gradientLayer && _gradientLayer.superlayer) {
        [_gradientLayer removeFromSuperlayer];
        _gradientLayer = nil;
    }
    if (_colors) {
        _gradientLayer = [[CAGradientLayer alloc] init];
        _gradientLayer.frame = self.bounds;
        NSMutableArray *colors = [NSMutableArray array];
        for(UIColor *color in _colors) {
            [colors addObject:(id)color.CGColor];
        }
        _gradientLayer.colors = colors;
        [self.layer insertSublayer:_gradientLayer atIndex:0];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
