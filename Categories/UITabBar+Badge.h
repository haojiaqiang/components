//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index corner:(CGFloat)corner;
- (void)removeBadgeOnItemIndex:(int)index;

- (void)showBadgeCountOnItemIndex:(int)index count:(int)count;
- (void)removeBadgeCountOnItemIndex:(int)index;
@end
