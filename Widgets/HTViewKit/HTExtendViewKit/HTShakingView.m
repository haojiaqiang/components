//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTShakingView.h"

@implementation HTShakingView

- (void) dealloc{
    self.onShaking = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] ) {
        [super motionEnded:motion withEvent:event];
    }
    if(event.subtype==UIEventSubtypeMotionShake){
        if(self.onShaking){
            self.onShaking();
        }
    }
}

- (BOOL) canBecomeFirstResponder{
    return YES;
}

@end
