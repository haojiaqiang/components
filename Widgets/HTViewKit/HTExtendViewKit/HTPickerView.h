//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//


#import "HTPopoverView.h"

@interface HTPickerView : HTPopoverView
{
    id _items;
}

@property (nonatomic, copy) void (^onOk)(UIPickerView* picker);

@property (nonatomic, assign) BOOL isModal;
@property (nonatomic, strong) id items;

@property (nonatomic, strong, readonly) UIPickerView *picker;

- (void) showInView:(UIView*) view;
- (void) selectRow:(NSInteger) row inComponent:(NSInteger)component;

@end
