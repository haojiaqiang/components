//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//


#import "HTView.h"

@interface HTRetryView : HTView
{
    UIColor *_iconBGColor, *_titleBGColor;
    NSString *_retryMessage;
}

@property (nonatomic, copy) void(^onRetry)();
@property (nonatomic, retain, readwrite, setter = setIconBGColor:, getter = getIcnBGColor) UIColor *iconBGColor;
@property (nonatomic, retain, readwrite, setter = setTitleBGColor:, getter = getTitleBGColor) UIColor *titleBGColor;
@property (nonatomic, copy) NSString *retryMessage;

@end
