//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Layout)

//让图片与文字上下布局，中心对齐
- (void)centerImageAndTitleWithSpace:(float)space;
- (void)centerImageAndTitle;

//让图片靠右
- (void)makeImageRightWithSpace:(float)space;
- (void)makeImageRight;

//重置Button布局
- (void)resetButtonLayout;

@end
