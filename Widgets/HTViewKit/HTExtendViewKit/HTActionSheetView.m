//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTActionSheetView.h"
#import "HTButton.h"
#import "Constants.h"
#import "UIUtility.h"
#import "UIView+ConvenienceFrame.h"

@interface HTActionSheetView ()
{
    HTView *_alphaView;
    HTView *_containerView;
}

@end

@implementation HTActionSheetView

- (instancetype)init {
    
    if (self = [super init]) {
        [self setupData];
        [self setupUI];
    };
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupData];
        [self setupUI];
    };
    return self;
}

- (void)setupData {
    
}

- (void)setupUI {
    self.backgroundColor = kClearColor;
    
    _alphaView = [[HTView alloc] initWithFrame:self.bounds];
    _alphaView.backgroundColor = kBlackColor;
    _alphaView.alpha = 0.4;
    [self addSubview:_alphaView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMaskViewOnClick)];
    [_alphaView addGestureRecognizer:tapGes];
    
    _containerView = [[HTView alloc] initWithFrame:CGRectMake(0, self.bottom, kDeviceWidth, (44 * kDeviceWidthScaleToiPhone6 * _titleArray.count + kAppCurvedScreenBottomMargin))];
    _containerView.backgroundColor = kWhiteColor;
    [self addSubview:_containerView];
    
    for (NSInteger i = 0; i < _titleArray.count; i++) {
        HTButton *btn = [[HTButton alloc] initWithFrame:CGRectMake(-1, i * 44 * kDeviceWidthScaleToiPhone6, kDeviceWidth + 2, 44 * kDeviceWidthScaleToiPhone6)];
        [btn setTitleColor:kHRGB(0x4e4e4e) forState:UIControlStateNormal];
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(handleBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = kAppFont(14);
        btn.tag = i;
        btn.layer.borderColor = kRGB(233, 233, 233).CGColor;
        btn.layer.borderWidth = 0.5f;
        [_containerView addSubview:btn];
    }
    
    [self presentListView];
}

- (void)presentListView {
    NSInteger count = _titleArray.count;
    [UIView animateWithDuration:0.25 animations:^{
        _containerView.transform = CGAffineTransformMakeTranslation(0, -44 * count * kDeviceWidthScaleToiPhone6);
        _alphaView.alpha = 0.4;
    }];
}

- (void)dismissListView {
    [UIView animateWithDuration:0.25 animations:^{
        _containerView.transform = CGAffineTransformIdentity;
        _alphaView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)handleBtnOnClick:(HTButton *)button {
    NSInteger tag = button.tag;
    __weak HTActionSheetView *weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        _containerView.transform = CGAffineTransformIdentity;
        _alphaView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (weakSelf.onTouch) {
            weakSelf.onTouch(tag);
        }
    }];
}

- (void)handleMaskViewOnClick {
    [self dismissListView];
}

@end
