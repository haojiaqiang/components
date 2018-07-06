//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTView.h"

typedef enum{
    HTSiblingViewDirectionLeft,
    HTSiblingViewDirectionRight,
    HTSiblingViewDirectionTop,
    HTSiblingViewDirectionBottom,
}HTSiblingViewDirection;

@interface HTSiblingView : HTView
@property (nonatomic, strong) UIView *siblingView;
@property (nonatomic, assign) BOOL binding;
@property (nonatomic, assign) HTSiblingViewDirection siblingViewDirection;

@end
