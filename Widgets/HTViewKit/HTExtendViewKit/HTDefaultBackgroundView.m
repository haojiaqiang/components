//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTDefaultBackgroundView.h"
#import "HTDeviceUtilities.h"
#import "HTViewKit.h"
#import "HTImageView.h"
#import "HTButton.h"
#import "HTLabel.h"
#import "Constants.h"
#import "HTAppConstants.h"
#import "HTColor.h"
#import "UIView+ConvenienceFrame.h"
#import "NSString+Utilities.h"

@implementation HTDefaultBackgroundView
{
    UITapGestureRecognizer *_tapGesture;
    HTImageView *_imageView;
    HTLabel*_titleLabel, *_subTitleLabel;
    HTButton *_btn;
    HTView *_containerView;
}


#pragma mark - Convenience Initializer

+ (HTDefaultBackgroundView *)defaultBackgroundViewWithType:(HTDefaultBackgroundViewType)tpye image:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle btnTitle:(NSString *)btnTitle completion:(void(^)())completion {
    HTDefaultBackgroundView *view = [[HTDefaultBackgroundView alloc] init];
    view.defaultViewType = tpye;
    view.image = image;
    view.title = title;
    view.subTitle = subTitle;
    view.btnTitle = btnTitle;
    view.onApply = ^{
        if (completion) {
            completion();
        }
    };
    return view;
}


#pragma mark - Life Cycle

- (void) dealloc {
    _onApply = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}


#pragma mark - UI Helper

- (void)setupUI {
    
    _containerView = [[HTView alloc] init];
    _containerView.backgroundColor = kClearColor;
    [self addSubview:_containerView];
    
    _imageView = [[HTImageView alloc] init];
    _imageView.contentMode = UIViewContentModeBottom;
    [_containerView addSubview:_imageView];
    
    _titleLabel = [[HTLabel alloc] init];
    _titleLabel.font = kAppAdaptFont(16);
    _titleLabel.textColor = [HTColor grayForTitleText];
    _titleLabel.numberOfLines = 1;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_containerView addSubview:_titleLabel];

    _subTitleLabel = [[HTLabel alloc] init];
    _subTitleLabel.font = kAppAdaptFont(16);
    _subTitleLabel.textColor = kHRGB(0x999999);
    _subTitleLabel.numberOfLines = 1;
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_containerView addSubview:_subTitleLabel];

    _btn = [[HTButton alloc] init];
    [_btn addTarget:self action:@selector(clickOnBtn) forControlEvents:UIControlEventTouchUpInside];
    _btn.titleLabel.font = kAppAdaptFont(14);
    [_btn setTitleColor:kHRGB(0x92a7c3) forState:UIControlStateNormal];
    [_btn setBackgroundColor:kHRGB(0xf6f6f6) forState:UIControlStateNormal];
    [_containerView addSubview:_btn];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToReload)];
    [self addGestureRecognizer:_tapGesture];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    switch (_defaultViewType) {
        case HTDefaultBackgroundViewNoData: {
            [self setFramesWithNoDataType];
            break;
        }
        case HTDefaultBackgroundViewRequestError: {
            [self setFramesWithRequstErrorType];
            break;
        }
        default: {
            break;
        }
    }
}

- (void)setFramesWithNoDataType {
    CGSize imageSize = _imageView.image.size;
    CGFloat imageViewW = imageSize.width;
    CGFloat imageViewH = imageSize.height;
    CGFloat padding = ALL_MARGIN;
    CGFloat labelH = kAppAdaptHeight(18);
    CGFloat imageAndLabelsH = imageViewH + labelH * 2;
    CGFloat height = self.height - imageAndLabelsH;
    _imageView.frame = CGRectMake((kDeviceWidth - imageViewW) * 0.5,  height / 3.0, imageViewW, imageViewH);
    
    CGFloat spaceY = height / 9;
    _titleLabel.frame = CGRectMake(padding, _imageView.bottom + spaceY, (kDeviceWidth - 2 * padding), labelH);
    CGFloat labelSpace = kAppAdaptHeight(10);
    _subTitleLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom + labelSpace, _titleLabel.width, labelH);
    
    CGFloat btnW = kDeviceWidth - kAppAdaptWidth(30);
    CGFloat btnH = (int)kAppAdaptHeight(45);
    _btn.frame = CGRectMake((kDeviceWidth - btnW) * 0.5, self.maxY - btnH - kAppAdaptHeight(20), btnW, btnH);
    _btn.layer.cornerRadius = kAppAdaptWidth(3);
    _btn.layer.masksToBounds = YES;
    
    _containerView.frame = CGRectMake(0, 0, self.width, self.height);
    _containerView.top -= _verticalOffset;
}

- (void)setFramesWithRequstErrorType {
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageViewW = imageSize.width;
    CGFloat imageViewH = imageSize.height;
    _imageView.frame = CGRectMake((kDeviceWidth - imageViewW) * 0.5, 0, imageViewW, imageViewH);
    
    CGFloat padding = ALL_MARGIN;
    CGFloat labelH = kAppAdaptHeight(18);
    _titleLabel.frame = CGRectMake(padding, _imageView.bottom + kAppAdaptHeight(55), (kDeviceWidth - 2 * padding), labelH);
    
    _subTitleLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.bottom + 14, _titleLabel.width, labelH);
    
    CGFloat containViewH = _subTitleLabel.bottom;
    _containerView.frame = CGRectMake(0, 0, kDeviceWidth, containViewH);
    _containerView.centerY = self.centerY;
    _containerView.top -= _verticalOffset;
}


#pragma mark - Event Response

- (void)tapToReload {
    if (_defaultViewType != HTDefaultBackgroundViewRequestError) return;
    if (self.onApply) {
        self.onApply();
    }
}

- (void)clickOnBtn {
    if (_defaultViewType != HTDefaultBackgroundViewNoData) return;
    if (self.onApply) {
        self.onApply();
    }
}


#pragma mark - Setter And Getter

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = _image;
    [self layoutIfNeeded];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    _subTitleLabel.text = _subTitle;
}

- (void)setBtnTitle:(NSString *)btnTitle {
    _btnTitle = btnTitle;
    
    if ([NSString isNullOrEmpty:_btnTitle]) {
        _btn.hidden = YES;
    } else {
        _btn.hidden = NO;
        [_btn setTitle:btnTitle forState:UIControlStateNormal];
    }
}

- (void)setVerticalOffset:(CGFloat)verticalOffset {
    _verticalOffset = verticalOffset;
    [self layoutIfNeeded];
}

- (void)setBtnBackgroundColor:(UIColor *)btnBackgroundColor {
    _btnBackgroundColor = btnBackgroundColor;
    [_btn setBackgroundColor:btnBackgroundColor forState:UIControlStateNormal];
}

- (void)setBtnTitleColor:(UIColor *)btnTitleColor {
    _btnTitleColor = btnTitleColor;
    [_btn setTitleColor:btnTitleColor forState:UIControlStateNormal];
}

@end
