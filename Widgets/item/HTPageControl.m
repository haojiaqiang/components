//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTPageControl.h"
#import <UIKit/UIKit.h>

@implementation HTPageControl
{
    UIImage *_activeImage;
    UIImage *_deactiveImage;
}

- (void)setActiveImage:(UIImage *)activeImage {
    _activeImage = activeImage;
    [self layoutDots];
}

- (void)setDeactiveImage:(UIImage *)deactiveImage {
    _deactiveImage = deactiveImage;
    [self layoutDots];
}

- (void)layoutDots {
    for (int i = 0; i < [self.subviews count]; i++) {
        UIView *dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage) {
            if ([dot isKindOfClass:[UIImageView class]]) {
                ((UIImageView *)dot).image = _activeImage;
            }
            else if (_activeImage) {
                dot.backgroundColor = [UIColor colorWithPatternImage:_activeImage];
            }
        }
        else {
            if ([dot isKindOfClass:[UIImageView class]]) {
                ((UIImageView *)dot).image = _deactiveImage;
            }
            else if (_deactiveImage) {
                dot.backgroundColor = [UIColor colorWithPatternImage:_deactiveImage];
            }
        }
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    [super setCurrentPage:currentPage];
    [self layoutDots];
}

@end
