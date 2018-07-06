//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTView.h"

typedef NS_ENUM(NSUInteger, HTDefaultBackgroundViewType) {
    HTDefaultBackgroundViewNoData = 1,
    HTDefaultBackgroundViewRequestError,
};

@interface HTDefaultBackgroundView : HTView

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, copy) NSString *btnTitle;

@property (nonatomic, strong) UIColor *btnTitleColor;

@property (nonatomic, strong) UIColor *btnBackgroundColor;

@property (nonatomic, copy) void (^onApply)();

@property (nonatomic, assign) HTDefaultBackgroundViewType defaultViewType;

@property (nonatomic, assign) CGFloat verticalOffset;

@property (nonatomic, assign) CGFloat viewHeight;


+ (HTDefaultBackgroundView *)defaultBackgroundViewWithType:(HTDefaultBackgroundViewType)tpye image:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle btnTitle:(NSString *)btnTitle completion:(void(^)())completion;

@end
