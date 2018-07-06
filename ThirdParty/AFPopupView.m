//
//  AFPopupView.m
//  AFPopup
//
//  Created by Alvaro Franco on 3/7/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import "AFPopupView.h"
#import <QuartzCore/QuartzCore.h>

#define CATransform3DPerspective(t, x, y) (CATransform3DConcat(t, CATransform3DMake(1, 0, 0, x, 0, 1, 0, y, 0, 0, 1, 0, 0, 0, 0, 1)))
#define CATransform3DMakePerspective(x, y) (CATransform3DPerspective(CATransform3DIdentity, x, y))
#define AF_POPUP_DURATION .3
#define AF_RENDER_SCALE .85

CG_INLINE CATransform3D
CATransform3DMake(CGFloat m11, CGFloat m12, CGFloat m13, CGFloat m14,
				  CGFloat m21, CGFloat m22, CGFloat m23, CGFloat m24,
				  CGFloat m31, CGFloat m32, CGFloat m33, CGFloat m34,
				  CGFloat m41, CGFloat m42, CGFloat m43, CGFloat m44)
{
	CATransform3D t;
	t.m11 = m11; t.m12 = m12; t.m13 = m13; t.m14 = m14;
	t.m21 = m21; t.m22 = m22; t.m23 = m23; t.m24 = m24;
	t.m31 = m31; t.m32 = m32; t.m33 = m33; t.m34 = m34;
	t.m41 = m41; t.m42 = m42; t.m43 = m43; t.m44 = m44;
	return t;
}

@interface AFPopupView ()

@property (nonatomic, strong) UIView *modalView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *backgroundShadowView;
@property (nonatomic, strong) UIImageView *renderImage;
@property (nonatomic, strong) UIView *rootView;

@end

@implementation AFPopupView

+(AFPopupView *)popupWithView:(UIView *)popupView inView:(UIView*) rootView withHeight:(CGFloat)height{
    
    //UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    //UIView *rootView = keyWindow.rootViewController.view;
    CGRect rect = CGRectMake(0, 0, rootView.frame.size.width, rootView.frame.size.height);
    
    if (rootView.transform.b != 0 && rootView.transform.c != 0) {
        rect = CGRectMake(0, 0, rootView.frame.size.height, rootView.frame.size.width);
    }
    
    AFPopupView *view = [[AFPopupView alloc] initWithFrame:rect];
    view.rootView = rootView;
    
    view.modalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
    
    view.modalView.backgroundColor = [UIColor clearColor];
    view.modalView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    view.blackView = [[UIView alloc] initWithFrame:view.frame];
    view.blackView.backgroundColor = [UIColor blackColor];
    view.blackView.autoresizingMask = view.modalView.autoresizingMask;
    
    view.backgroundShadowView = [[UIView alloc] initWithFrame:view.frame];
    view.backgroundShadowView.backgroundColor = [UIColor blackColor];
    view.backgroundShadowView.alpha = 0.0;
    view.backgroundShadowView.autoresizingMask = view.modalView.autoresizingMask;
    
    view.renderImage = [[UIImageView alloc] initWithFrame:view.frame];
    view.renderImage.autoresizingMask = view.modalView.autoresizingMask;
    view.renderImage.contentMode = UIViewContentModeScaleToFill;
    
    [view.modalView addSubview:popupView];
    [view addSubview:view.blackView];
    [view addSubview:view.renderImage];
    [view addSubview:view.backgroundShadowView];
    [view addSubview:view.modalView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(handleTapBackground:)];
    [view.backgroundShadowView addGestureRecognizer:tapGesture];
    
    return view;
}

- (void) handleTapBackground:(UITapGestureRecognizer*) recognizer {
    if (_closable) {
        [self hide];
    }
}

- (void) show{
    //UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    //UIView *rootView = keyWindow.rootViewController.view;
    
    CGRect rect = CGRectMake(0, 0, _rootView.frame.size.width, _rootView.frame.size.height);
    if(_rootView.transform.b != 0 && _rootView.transform.c != 0)
        rect = CGRectMake(0, 0, _rootView.frame.size.height, _rootView.frame.size.width);
    self.frame = rect;
    
    UIImage *rootViewRenderImage = [self imageWithView:_rootView];
    _renderImage.image = rootViewRenderImage;
    
    _backgroundShadowView.alpha = 0.0;
    [_rootView addSubview:self];
    _modalView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height+_modalView.frame.size.height/2);
    
    CGFloat w = _renderImage.frame.size.width, h = _renderImage.frame.size.height;
    
    [UIView animateWithDuration:AF_POPUP_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _backgroundShadowView.alpha = 0.4;
                         _renderImage.layer.transform = CATransform3DMakePerspective(0, -0.001*AF_RENDER_SCALE);
                     }
     
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:AF_POPUP_DURATION animations:^{
                             
                             float newWidht = w * AF_RENDER_SCALE;
                             float newHeight = h * AF_RENDER_SCALE;
                             _renderImage.frame = CGRectMake(([[UIScreen mainScreen]bounds].size.width - newWidht) / 2, 22, newWidht, newHeight);
                             _renderImage.layer.transform = CATransform3DMakePerspective(0, 0);
                         } completion:^(BOOL finished) {
                             //[UIView animateWithDuration:0.1 animations:^{
                             //}];
                         }];
                     }];
    
    [UIView animateWithDuration:AF_POPUP_DURATION*1.5 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _modalView.center = CGPointMake(self.frame.size.width/2, [UIScreen mainScreen].bounds.size.height -_modalView.frame.size.height/2);//self.center;
                     }
                     completion:^(BOOL finished) {
                         
                     }];

}

- (void) hide{
    [self hideOnCompletion:nil];
}

- (void) hideOnCompletion:(void (^)())completion{
    
    [UIView animateWithDuration:AF_POPUP_DURATION*2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _modalView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height+_modalView.frame.size.height/2);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    [UIView animateWithDuration:AF_POPUP_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         _backgroundShadowView.alpha = 0.0;
                         _renderImage.layer.transform = CATransform3DMakePerspective(0, -0.001*AF_RENDER_SCALE);
                     }
     
                     completion:^(BOOL finished) {

                         [UIView animateWithDuration:AF_POPUP_DURATION animations:^{
                             
                             _renderImage.frame = [[UIScreen mainScreen]bounds];
                             _renderImage.layer.transform = CATransform3DMakePerspective(0, 0);
                         } completion:^(BOOL finished) {
                             [self removeFromSuperview];
                             if (completion) {
                                 completion();
                             }
                         }];
                     }];
}

-(UIImage *)imageWithView:(UIView *)view {
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(_renderImage.frame.size, view.opaque, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(_renderImage.frame.size);
    }
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return backgroundImage;
}

@end
