//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTSiblingView.h"

@implementation HTSiblingView
{
    CGRect _siblingViewFrame, _selfFrame;
}

- (void) setFrame:(CGRect)frame{
    _selfFrame = self.frame;
    [super setFrame:frame];
    [self checkSiblingView:frame.origin];
}

- (void) checkSiblingView:(CGPoint) center{
    if (_binding) {
        CGRect siblingFrame = _siblingViewFrame;
        switch (_siblingViewDirection) {
            case HTSiblingViewDirectionLeft:
            case HTSiblingViewDirectionRight:
                siblingFrame.origin.x -= _selfFrame.origin.x-center.x;
                break;
            case HTSiblingViewDirectionTop:
            case HTSiblingViewDirectionBottom:
                siblingFrame.origin.y -= _selfFrame.origin.y-center.y;
                break;
                
            default:
                break;
        }
        _siblingView.frame = siblingFrame;
        _siblingViewFrame = siblingFrame;
    }
}

- (void) setCenter:(CGPoint)center{
    _selfFrame = self.frame;
    [super setCenter:center];
    [self checkSiblingView:CGPointMake(center.x-_selfFrame.size.width/2, center.y-_selfFrame.size.height/2)];
}

- (void) setBinding:(BOOL)binding{
    _binding = binding;
    _siblingViewFrame = self.siblingView.frame;
}

- (BOOL) isBinding{
    return _binding;
}

- (void) dealloc{
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

@end
