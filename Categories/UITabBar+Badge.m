//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "UITabBar+Badge.h"
#import "HTBadgeView.h"
#import "Constants.h"

@implementation UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index corner:(CGFloat)corner {
    [self removeBadgeOnItemIndex:index];
    /*
    UIView *badgeView = [[UIView alloc] init];
    badgeView.tag = 666 + index;
    badgeView.layer.borderColor = kHRGB(0xF9F9F9).CGColor;
    badgeView.layer.borderWidth = 1;
    badgeView.layer.cornerRadius = corner;
    badgeView.backgroundColor = kHRGB(0xedba11);
     */
    CGFloat wh = corner * 2;
    CGFloat percentX = (index + 0.56) / self.items.count;
    CGFloat x = percentX * CGRectGetWidth(self.frame);
    CGFloat y = CGRectGetHeight(self.frame) * 0.10;
    
    HTBadgeView *badgeView = [[HTBadgeView alloc] initWithFrame:CGRectMake(x, y, wh, wh)];
    badgeView.tag = 888 + index;
    badgeView.borderColor = kHRGB(0xF9F9F9);
    badgeView.borderWidth = 1.0f;
    badgeView.badgeColor = kHRGB(0xff5b49);
    
    [self addSubview:badgeView];
}

- (void)removeBadgeOnItemIndex:(int)index {
    UIView * badgeView = [self viewWithTag:(888 + index)];
    
    if (badgeView) {
        
        [badgeView removeFromSuperview];
    }
}

- (void)showBadgeCountOnItemIndex:(int)index count:(int)count {
    
    UITabBarItem * tabBarItem = [self getTabBarItemWithIndex:index];
    
    if (tabBarItem && count) {
        
        [self removeBadgeOnItemIndex:index];//如果有小红点的话，需要移除
        
        if (count>99) {
            
            tabBarItem.badgeValue =@"99+";
        }else{
           
            tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",count];
        }
        
    }else{
        
        [self removeBadgeCountOnItemIndex:index];
    }
}

- (void)removeBadgeCountOnItemIndex:(int)index {
    
    UITabBarItem * tabBarItem = [self getTabBarItemWithIndex:index];
    
    if (tabBarItem) {
        
        tabBarItem.badgeValue = nil;
    }
}

- (UITabBarItem *)getTabBarItemWithIndex:(int)index{
    
    return  [self.items objectAtIndex:index];
}

@end
