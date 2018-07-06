//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTBarButtonItem.h"
#import "HTLabel.h"
#import "Constants.h"

@implementation HTBarButtonItem
{
    HTView *_badge;
    HTLabel *_badgeLabel;
}

- (void) showBadge:(BOOL)show withFrame:(CGRect)frame{
    if (_buttonItem) {
        HTView *badge = [self badgeWithFrame:frame];
        if (!badge.superview) {
            [_buttonItem addSubview:badge];
        }
        badge.hidden = !show;
    }
}

- (void) showBadge:(BOOL)show withNumber:(int)badgeNumber withFrame:(CGRect)frame{
    if (_buttonItem) {
        HTView *badge = [self badgeWithFrame:frame];
        if (!badge.superview) {
            [_buttonItem addSubview:badge];
        }
        [self setBadgeNumber:badgeNumber];
    }
}

- (HTView*) badgeView {
    return _badge;
}

- (HTView*) badgeWithFrame:(CGRect)frame{
    if (!_badge) {
        _badge = [[HTView alloc] initWithFrame:frame andRadius:MIN(frame.size.width, frame.size.height)/2];
        _badge.backgroundColor = kRGB(212, 96, 32);
        if (_buttonItem) {
            [_buttonItem addSubview:_badge];
        }
    }
    return _badge;
}

- (void) setBadgeNumber:(int) badgeNumber{
    if (!_badgeLabel) {
        HTView *badge = [self badgeWithFrame:CGRectZero];
        _badgeLabel = [[HTLabel alloc] initWithFrame:badge.bounds];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.textColor = kWhiteColor;
        _badgeLabel.font = kAppFont(_badgeLabel.frame.size.width-4);
        [badge addSubview:_badgeLabel];
    }
    _badgeLabel.text = [NSString stringWithFormat:@"%d", badgeNumber];
    _badge.hidden = badgeNumber==0;
}

- (void) setCustomView:(UIView *)customView{
    [super setCustomView:customView];
    _buttonItem = customView;
}

@end
