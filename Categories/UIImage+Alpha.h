//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIImage (Alpha)

- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;
- (UIImage *)imageByApplyingAlpha:(CGFloat )alpha;

@end
