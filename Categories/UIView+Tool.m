//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "UIView+Tool.h"
#import "Constants.h"

@implementation UIView (Tool)

- (void)addDebugBorder {
    self.layer.borderColor = kRandomColor.CGColor;
    self.layer.borderWidth = 2;
}

- (void)addDebugBorderWithColor:(UIColor *)color {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 2;
}

@end
