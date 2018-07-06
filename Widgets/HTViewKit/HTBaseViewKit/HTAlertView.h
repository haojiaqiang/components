//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTPopoverView.h"

@class HTButton;

@interface HTAlertView : HTPopoverView

@property (nonatomic, copy) void (^clickButtonAtIndex)(HTAlertView *alertView, NSInteger buttonIndex);

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;

- (id)initWithCustomView:(UIView *)view title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;

- (void)setActionEnabled:(BOOL)enabled atIndex:(NSInteger)buttonIndex;

- (HTButton *) buttonAtIndex:(NSInteger)buttonIndex;

@end
