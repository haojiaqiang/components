//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTSideMenuViewController.h"
#import "Constants.h"
#import "HTBarButtonItem.h"

#define PAN_SCALE_END_LEFT 0.8
#define PAN_SCALE_END_RIGHT 0.8
#define PAN_END_EDGE_WIDTH_LEFT (int)(kDeviceWidth/3)
#define PAN_END_EDGE_WIDTH_RIGHT 40
#define PAN_SPEED 0.5

@interface HTSideMenuViewController ()

@end

@implementation HTSideMenuViewController
{
    UIPanGestureRecognizer *_panGesture;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        _sideMenuState = HTSideMenuStateClosed;
    }
    return self;
}

- (id) initWithLeftVC:(UIViewController *)leftVC andRightVC:(UIViewController *)rightVC{
    self = [super init];
    if(self){
        _leftVC = leftVC;
        _rightVC = rightVC;
    }
    return self;
}

- (void) dealloc{
    self.onClickSideMenu = nil;
    self.onPanSideMenu = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self initNavItems];
    [self _initSideMenu];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGesture];
}

- (void) setLeftVC:(UIViewController *)leftVC{
    if(_leftVC){
        [_leftVC.view removeFromSuperview];
        _leftVC = nil;
    }
    _leftVC = leftVC;
    [self initLeftMenu];
}

- (void) setRightVC:(UIViewController *)rightVC{
    if(_rightVC){
        [_rightVC.view removeFromSuperview];
        _rightVC = nil;
    }
    _rightVC = rightVC;
    [self initRightMenu];
}

- (UIViewController*) getLeftVC{
    return _leftVC;
}

- (UIViewController*) getRightVC{
    return _rightVC;
}

- (void) _initSideMenu{
    [self initLeftMenu];
    [self initRightMenu];
}

- (void) initLeftMenu{
    if(_leftVC){
        _leftVC.view.hidden = YES;
        [self.mainView.superview insertSubview:_leftVC.view belowSubview:self.mainView];
        _sideMenuDirection |= HTSideMenuDirectionLeft;
        [self initLeftItem];
    }
}

- (void) initRightMenu{
    if(_rightVC){
        _rightVC.view.hidden = YES;
        [self.mainView.superview insertSubview:_rightVC.view belowSubview:self.mainView];
        _sideMenuDirection |= HTSideMenuDirectionRight;
        [self initRightItem];
    }
}

- (void)initNavItems{
    [self initLeftItem];
    [self initRightItem];
}

- (void) initLeftItem{
    self.navigationItem.leftBarButtonItems = nil;
    HTBarButtonItem *leftBarButtonItem = [[HTBarButtonItem alloc] initWithImage:[UIImage imageNamed:_leftIconName] style:UIBarButtonItemStylePlain target:self action:@selector(handleLeftMenu:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    leftBarButtonItem.buttonItem = [self buttonItemForBarButton:leftBarButtonItem];
}

- (void) initRightItem{
    self.navigationItem.rightBarButtonItems = nil;
    HTBarButtonItem *rightBarButtonItem = [[HTBarButtonItem alloc] initWithImage:[UIImage imageNamed:_rightIconName] style:UIBarButtonItemStylePlain target:self action:@selector(handleRightMenu:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    rightBarButtonItem.buttonItem = [self buttonItemForBarButton:rightBarButtonItem];
}

- (void) handleLeftMenu:(UIBarButtonItem*) sender{
    BOOL on = NO;
    if(self.mainView.center.x!=kDeviceWidth/2){
        [self toggleLeftMenu:NO onCompletion:nil];
    }
    else{
        on = YES;
        [self toggleLeftMenu:YES onCompletion:nil];
    }
    if(self.onClickSideMenu){
        self.onClickSideMenu(HTSideMenuDirectionLeft, on);
    }
}

- (void) toggleLeftMenu:(BOOL)on onCompletion:(void (^)(BOOL finished))completion{
    _leftVC.view.hidden = NO;
    _rightVC.view.hidden = YES;
    if(on){
        [self addTapGesture];
    }else{
        [self removeTapGesture];
    }
    [self sideMenuWillShow:on onState:HTSideMenuStateOpenedLeft];
    [UIView animateWithDuration:0.25 animations:^{
        self.mainView.center = on? CGPointMake(kDeviceWidth+kDeviceWidth*PAN_SCALE_END_LEFT/2-PAN_END_EDGE_WIDTH_LEFT*PAN_SCALE_END_LEFT, kDeviceHeight/2) : CGPointMake(kDeviceWidth/2, kDeviceHeight/2);
        self.mainView.transform = on? CGAffineTransformMakeScale(PAN_SCALE_END_LEFT, PAN_SCALE_END_LEFT) : CGAffineTransformMakeScale(1.0, 1.0);
        //[self onPan:HTSideMenuDirectionLeft withValue:on? 1 : 0];
    } completion:^(BOOL finished) {
        [self sideMenuDidShow:on onState:HTSideMenuStateOpenedLeft];
        _sideMenuState = on? HTSideMenuStateOpenedLeft:HTSideMenuStateClosed;
        if(!on){
            [self hideSideMenus];
        }
        _leftVC.view.userInteractionEnabled = YES;
        _rightVC.view.userInteractionEnabled = YES;
    }];
}

- (void) handleRightMenu:(UIBarButtonItem*) sender{
    BOOL on = NO;
    if(self.mainView.center.x!=kDeviceWidth/2){
        [self toggleRightMenu:NO onCompletion:nil];
    }
    else{
        on = YES;
        [self toggleRightMenu:YES onCompletion:nil];
    }
    if(self.onClickSideMenu){
        self.onClickSideMenu(HTSideMenuDirectionRight, on);
    }
}

- (void) toggleRightMenu:(BOOL)on onCompletion:(void (^)(BOOL finished))completion{
    _rightVC.view.hidden = NO;
    _leftVC.view.hidden = YES;
    if(on){
        [self addTapGesture];
    }else{
        [self removeTapGesture];
    }
    [self sideMenuWillShow:on onState:HTSideMenuStateOpenedRight];
    [UIView animateWithDuration:0.25 animations:^{
        self.mainView.center = on? CGPointMake(PAN_END_EDGE_WIDTH_RIGHT*PAN_SCALE_END_RIGHT-kDeviceWidth*PAN_SCALE_END_RIGHT/2, kDeviceHeight/2) : CGPointMake(kDeviceWidth/2, kDeviceHeight/2);
        self.mainView.transform = on? CGAffineTransformMakeScale(PAN_SCALE_END_RIGHT, PAN_SCALE_END_RIGHT) : CGAffineTransformMakeScale(1.0, 1.0);
        //[self onPan:HTSideMenuDirectionRight withValue:on? 1 : 0];
    } completion:^(BOOL finished) {
        [self sideMenuDidShow:on onState:HTSideMenuStateOpenedRight];
        _sideMenuState = on? HTSideMenuStateOpenedRight:HTSideMenuStateClosed;
        if(!on){
            [self hideSideMenus];
        }
        _leftVC.view.userInteractionEnabled = YES;
        _rightVC.view.userInteractionEnabled = YES;
    }];
}

- (UIView*) mainView{
    return self.view;
}

- (void) sideMenuWillShow:(BOOL)show onState:(HTSideMenuState)sideMenuState{
    
}

- (void) sideMenuDidShow:(BOOL)show onState:(HTSideMenuState)sideMenuState{
    
}

- (void) addTapGesture{
    [self removeTapGesture];
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapped:)];
    [self.view addGestureRecognizer:_tapGesture];
}

- (void) removeTapGesture{
    if(_tapGesture){
        [self.view removeGestureRecognizer:_tapGesture];
        _tapGesture = nil;
    }
}

- (void) handleTapped:(UITapGestureRecognizer*) recognizer{
    if(recognizer.state==UIGestureRecognizerStateEnded){
        [self closeSideMenu];
    }
}

- (void) handlePan:(UIPanGestureRecognizer*) recognizer{
    CGPoint point = [recognizer translationInView:self.view.superview];
    if(recognizer.state==UIGestureRecognizerStateBegan){
        _leftVC.view.userInteractionEnabled = NO;
        _rightVC.view.userInteractionEnabled = NO;
        _panned = 0;
    }
    else if(recognizer.state==UIGestureRecognizerStateChanged){
        _panned += point.x*PAN_SPEED;
        CGPoint vel = [recognizer velocityInView:self.view];
        CGFloat scale = -1;
        if (vel.x>=0){
            if((_sideMenuDirection & HTSideMenuDirectionLeft)==HTSideMenuDirectionLeft || self.mainView.frame.origin.x<0){
                self.mainView.center = CGPointMake(self.mainView.center.x + point.x*PAN_SPEED,self.mainView.center.y);
                CGFloat x = self.mainView.frame.origin.x;
                if (x<0) {
                    x = kDeviceWidth-self.mainView.frame.size.width-x;
                }
                if (self.mainView.frame.origin.x<0) {
                    scale = x/(kDeviceWidth-PAN_END_EDGE_WIDTH_RIGHT*PAN_SCALE_END_RIGHT)*(1-PAN_SCALE_END_RIGHT);
                } else {
                    scale = x/(kDeviceWidth-PAN_END_EDGE_WIDTH_LEFT*PAN_SCALE_END_LEFT)*(1-PAN_SCALE_END_LEFT);
                }
                self.mainView.transform = CGAffineTransformMakeScale(1-scale,1-scale);
                [recognizer setTranslation:CGPointMake(0, 0) inView:self.mainView.superview];
            }
        }
        else
        {
            if((_sideMenuDirection & HTSideMenuDirectionRight)==HTSideMenuDirectionRight || self.mainView.frame.origin.x>0){
                self.mainView.center = CGPointMake(self.mainView.center.x + point.x*PAN_SPEED,self.mainView.center.y);
                CGFloat x = self.mainView.frame.origin.x;
                if (x<0) {
                    x = kDeviceWidth-self.mainView.frame.size.width-x;
                }
                if (self.mainView.frame.origin.x>0) {
                    scale = x/(kDeviceWidth-PAN_END_EDGE_WIDTH_LEFT*PAN_SCALE_END_LEFT)*(1-PAN_SCALE_END_LEFT);
                } else {
                    scale = x/(kDeviceWidth-PAN_END_EDGE_WIDTH_RIGHT*PAN_SCALE_END_RIGHT)*(1-PAN_SCALE_END_RIGHT);
                }
                self.mainView.transform = CGAffineTransformMakeScale(1-scale,1-scale);
                [recognizer setTranslation:CGPointMake(0, 0) inView:self.mainView.superview];
            }
        }
        _rightVC.view.hidden = self.mainView.frame.origin.x>=0;
        _leftVC.view.hidden = self.mainView.frame.origin.x<=0;
        if(scale!=-1){
            CGFloat percentage = 1.0;
            HTSideMenuDirection direction;
            if(self.mainView.frame.origin.x>=0){
                direction = HTSideMenuDirectionLeft;
                if (PAN_SCALE_END_LEFT>0 && PAN_SCALE_END_LEFT<1) {
                    percentage = scale/(1.0-PAN_SCALE_END_LEFT);
                } else {
                    percentage = self.mainView.frame.origin.x/(kDeviceWidth-PAN_END_EDGE_WIDTH_LEFT);
                }
            }else{
                direction = HTSideMenuDirectionRight;
                if (PAN_SCALE_END_RIGHT>0 && PAN_SCALE_END_RIGHT<1) {
                    percentage = scale/(1.0-PAN_SCALE_END_RIGHT);
                } else {
                    percentage = self.mainView.frame.origin.x/(kDeviceWidth-PAN_END_EDGE_WIDTH_RIGHT);
                }
            }
            if (percentage<0) {
                percentage = 0;
            }
            else if(percentage>1){
                percentage = 1;
            }
            [self onPan:direction withValue:percentage];
        }
    }
    if(recognizer.state==UIGestureRecognizerStateEnded){
        if (_panned>kDeviceWidth/3*PAN_SPEED){
            if((_sideMenuDirection & HTSideMenuDirectionLeft)==HTSideMenuDirectionLeft){
                if(_sideMenuState==HTSideMenuStateOpenedLeft || _sideMenuState==HTSideMenuStateClosed){
                    [self toggleLeftMenu:YES onCompletion:nil];
                    if(self.onPanSideMenu){
                        self.onPanSideMenu(HTSideMenuDirectionLeft, YES);
                    }
                }
                else if(_sideMenuState==HTSideMenuStateOpenedRight){
                    [self toggleRightMenu:NO onCompletion:nil];
                }
            }else{
                if (self.mainView.frame.origin.x!=0) {
                    [self closeSideMenu];
                }
            }
        }
        else if (_panned<-kDeviceWidth/3*PAN_SPEED) {
            if((_sideMenuDirection & HTSideMenuDirectionRight)==HTSideMenuDirectionRight){
                if(_sideMenuState==HTSideMenuStateOpenedRight || _sideMenuState==HTSideMenuStateClosed){
                    [self toggleRightMenu:YES onCompletion:nil];
                    if(self.onPanSideMenu){
                        self.onPanSideMenu(HTSideMenuDirectionRight, YES);
                    }
                }
                else if(_sideMenuState==HTSideMenuStateOpenedLeft){
                    [self toggleLeftMenu:NO onCompletion:nil];
                }
            }else{
                if (self.mainView.frame.origin.x!=0) {
                    [self closeSideMenu];
                }
            }
        }
        else {
            [self closeSideMenu];
        }
    }
}

- (void) onPan:(HTSideMenuDirection)direction withValue:(CGFloat)f{
    
}

- (void) openLeftMenu{
    [self toggleLeftMenu:YES onCompletion:nil];
}

- (void) openRightMenu{
    [self toggleRightMenu:YES onCompletion:nil];
}

- (void) closeSideMenu{
    [self sideMenuWillShow:NO onState:_sideMenuState];
    [UIView animateWithDuration:0.25 animations:^{
        self.mainView.center = CGPointMake(kDeviceWidth/2, kDeviceHeight/2);
        self.mainView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self sideMenuDidShow:NO onState:_sideMenuState];
        [self removeTapGesture];
        _sideMenuState = HTSideMenuStateClosed;
        [self hideSideMenus];
    }];
}

- (void) hideSideMenus{
    if(_leftVC){
        _leftVC.view.hidden = YES;
    }
    if(_rightVC){
        _rightVC.view.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
