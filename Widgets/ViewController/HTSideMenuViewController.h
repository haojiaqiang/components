//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTLocationViewController.h"

typedef enum{
    HTSideMenuStateClosed,
    HTSideMenuStateOpenedLeft,
    HTSideMenuStateOpenedRight,
}HTSideMenuState;

typedef enum{
    HTSideMenuDirectionLeft=1<<0,
    HTSideMenuDirectionRight=1<<1,
}HTSideMenuDirection;

@protocol HTSideMenuDelegate;

@interface HTSideMenuViewController : HTLocationViewController
{
    HTSideMenuState _sideMenuState;
    UIViewController *_leftVC, *_rightVC;
    UITapGestureRecognizer *_tapGesture;
    CGFloat _panned;
    NSString *_leftIconName, *_rightIconName;
}
@property (nonatomic, assign) HTSideMenuDirection sideMenuDirection;
@property (nonatomic, assign) id<HTSideMenuDelegate> delegate;
@property (nonatomic, strong, readwrite, setter=setLeftVC:, getter=getLeftVC) UIViewController *leftVC;
@property (nonatomic, strong, readwrite, setter=setRightVC:, getter=getRightVC) UIViewController *rightVC;
@property (nonatomic, copy) NSString *leftIconName;
@property (nonatomic, copy) NSString *rightIconName;
@property (nonatomic, copy) void (^onClickSideMenu)(HTSideMenuDirection direction, BOOL state);
@property (nonatomic, copy) void (^onPanSideMenu)(HTSideMenuDirection direction, BOOL state);

- (void) initLeftItem;
- (void) initRightItem;

- (instancetype) initWithLeftVC:(UIViewController*) leftVC andRightVC:(UIViewController*) rightVC;
- (UIView*) mainView;
- (void) sideMenuWillShow:(BOOL) show onState:(HTSideMenuState) sideMenuState;
- (void) sideMenuDidShow:(BOOL) show onState:(HTSideMenuState) sideMenuState;
- (void) closeSideMenu;
- (void) openLeftMenu;
- (void) openRightMenu;
- (void) onPan:(HTSideMenuDirection) direction withValue:(CGFloat) f;
@end

@protocol HTSideMenuDelegate <NSObject>

@optional
- (void) sideMenu:(HTSideMenuViewController*) sideMenu willOpen:(BOOL) open onState:(HTSideMenuState) sideMenuState;
- (void) sideMenu:(HTSideMenuViewController*) sideMenu didOpen:(BOOL) open onState:(HTSideMenuState) sideMenuState;

@end
