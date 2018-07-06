//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTTextField.h"
#import "constants.h"

@implementation HTTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _placeholderColor = kRGB(195, 195, 195);
        _placeholderAlilgnment = HTTextFieldPlaceholderAlignmentLeft;
    }
    return self;
}

- (void) drawPlaceholderInRect:(CGRect)rect {
    if (_placeholderColor) {
        CGSize textSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
        CGFloat x = 0;
        if (_placeholderAlilgnment == HTTextFieldPlaceholderAlignmentCenter) {
            CGSize placeholderSize = [self.placeholder sizeWithAttributes:@{NSFontAttributeName:self.font}];
            x = MAX(0, (self.bounds.size.width - placeholderSize.width) / 2);
        }
        else if (_placeholderAlilgnment == HTTextFieldPlaceholderAlignmentRight) {
            CGSize placeholderSize = [self.placeholder sizeWithAttributes:@{NSFontAttributeName:self.font}];
            x = MAX(0, (self.bounds.size.width - placeholderSize.width));
        }
        [self.placeholder drawAtPoint:CGPointMake(x, (rect.size.height / 2 - textSize.height / 2 - .5))
                       withAttributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:_placeholderColor}];
    }
    else {
        [super drawPlaceholderInRect:rect];
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
