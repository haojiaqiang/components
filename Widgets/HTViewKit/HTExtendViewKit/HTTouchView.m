//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTTouchView.h"

@implementation HTTouchView
@synthesize touchView;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if(self.touchView && !self.touchView.hidden){
        if(CGRectContainsPoint(self.frame, point)){
            return self.touchView;
        }
    }
    return [super hitTest:point withEvent:event];
}

@end
