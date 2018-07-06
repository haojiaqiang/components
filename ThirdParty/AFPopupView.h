//
//  AFPopupView.h
//  AFPopup
//
//  Created by Alvaro Franco on 3/7/14.
//  Copyright (c) 2014 AlvaroFranco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFPopupView : UIView

+(AFPopupView *)popupWithView:(UIView *)popupView inView:(UIView*) view withHeight:(CGFloat) height;

@property (nonatomic, assign) BOOL closable;
- (void) show;
- (void) hide;
- (void) hideOnCompletion:(void(^)())completion;

@end
