//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTView.h"

@interface HTBarButtonItem : UIBarButtonItem
{
    UIView *_buttonItem;
    UIImageView *_imageView;
}
@property (nonatomic, strong) UIView *buttonItem;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong, readonly) HTView *badgeView;

- (void) showBadge:(BOOL) show withFrame:(CGRect) frame;
- (void) showBadge:(BOOL) show withNumber:(int) badgeNumber withFrame:(CGRect) frame;

@end
