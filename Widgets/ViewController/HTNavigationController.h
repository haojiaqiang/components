//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTNavigationController : UINavigationController
{
    BOOL _autorotate;
    UIInterfaceOrientationMask _orientationMask;
    UIInterfaceOrientation _preferredOrientation;
}

@property (nonatomic, assign, readwrite, setter = setAutorotate:, getter = isAutorotate) BOOL autorotate;

- (void) setOrientationMask:(UIInterfaceOrientationMask) orientationMask;
- (void) setPreferredOrientation:(UIInterfaceOrientation) preferredOrientation;
- (void) setInteractivePopGestureRecognizerEnabled:(BOOL) enabled;

@end
