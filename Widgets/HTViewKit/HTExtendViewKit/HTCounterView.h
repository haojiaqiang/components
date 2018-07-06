//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTView.h"

@interface HTCounterView : HTView
{
    int _value, _step, _minValue, _maxValue;
}
@property (nonatomic, assign) int value;
@property (nonatomic, assign) int step;
@property (nonatomic, assign) int minValue;
@property (nonatomic, assign) int maxValue;

@property (nonatomic, copy) void (^onKeyboardShow)(BOOL show, CGSize keyboardSize);

@end
