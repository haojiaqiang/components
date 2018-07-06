//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTView.h"

@interface HTNavigationView : HTView

- (instancetype) initWithRootView:(UIView*) rootView;

- (void) pushView:(UIView*) view animated:(BOOL) animated;

- (void) popViewAnimated:(BOOL) animated;

- (void) popToRootViewAnimated:(BOOL) animated;

@end
