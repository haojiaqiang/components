//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTView.h"

typedef NS_ENUM(NSInteger, HTPopoverViewDirection) {
    HTPopoverViewDirectionFromTop,
    HTPopoverViewDirectionFromCenter,
    HTPopoverViewDirectionFromBottom,
};

typedef NS_ENUM(NSInteger, HTPopoverViewCloseDirection) {
    HTPopoverViewCloseDirectionFromTop,
    HTPopoverViewCloseDirectionFromCenter,
    HTPopoverViewCloseDirectionFromBottom,
};

typedef NS_ENUM(NSInteger, HTPopoverViewPosition) {
    HTPopoverViewPositionTop,
    HTPopoverViewPositionMiddle,
    HTPopoverViewPositionBottom,
    HTPopoverViewPositionCustom,
};

@interface HTPopoverView : HTView
{
    HTView *_maskView;
    
    HTPopoverViewDirection _direction;
    HTPopoverViewPosition _position;
    BOOL _enableDynamicAnimator;
}
@property (nonatomic, copy) void (^popviewWillShow)(HTPopoverView *view);
@property (nonatomic, copy) void (^popviewDidShow)(HTPopoverView *view);
@property (nonatomic, copy) void (^popviewWillClose)(HTPopoverView *view);
@property (nonatomic, copy) void (^popviewDidClose)(HTPopoverView *view);

@property (nonatomic, assign) BOOL closable; // Enable tap to close
@property (nonatomic, assign) BOOL enableDynamicAnimator;

@property (nonatomic, assign) HTPopoverViewDirection direction;
@property (nonatomic, assign) HTPopoverViewPosition position;
@property (nonatomic, assign) CGFloat positionY; // Only take effect when position set to HTPopoverViewPositionCustom
@property (nonatomic, strong) UIColor *maskColor;

@property (nonatomic, assign) HTPopoverViewCloseDirection closeDirection;

- (void)show;
- (void)showInView:(UIView *)view;
- (void)close;
- (void)closeOnCompletion:(void(^)(HTPopoverView *popoverView))completionBlock;

@end
