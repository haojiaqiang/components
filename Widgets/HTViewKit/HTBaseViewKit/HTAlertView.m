//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTAlertView.h"
#import "HTLabel.h"
#import "NSString+Utilities.h"
#import "Constants.h"
#import "HTViewKit.h"

@implementation HTAlertView
{
    NSString *_title;
    NSString *_message;
    NSString *_cancelButtonTitle;
    NSString *_okButtonTitle;
    
    UIView *_customView;
    HTButton *_cancelButton;
    HTButton *_okButton;
    
    BOOL _readyToLoadSubviews;
}

const CGFloat alertWidth = 270.0f;
const CGFloat alertRadius = 13.0f;

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle  {
    self = [super initWithFrame:CGRectMake((kDeviceWidth - alertWidth) / 2, 0, alertWidth, 44) andRadius:alertRadius];
    if (self) {
        _readyToLoadSubviews = YES;
        _title = title;
        _message = message;
        _cancelButtonTitle = cancelButtonTitle;
        _okButtonTitle = okButtonTitle;
        
        [self loadSubviews];
    }
    return self;
}

- (id)initWithCustomView:(UIView *)view title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle {
    self = [super initWithFrame:CGRectMake((kDeviceWidth - alertWidth) / 2, 0, alertWidth, 44) andRadius:alertRadius];
    if (self) {
        _readyToLoadSubviews = YES;
        _title = title;
        _message = message;
        _cancelButtonTitle = cancelButtonTitle;
        _okButtonTitle = okButtonTitle;
        _customView = view;
        
        [self loadSubviews];
    }
    return self;
}

- (void)loadSubviews {
    if (!_readyToLoadSubviews) {
        return;
    }
    if ([NSString isNullOrEmpty:_message] && !_customView) {
        return;
    }
    [super loadSubviews];
    self.backgroundColor = kWhiteColor;
    self.direction = HTPopoverViewDirectionFromCenter;
    self.closeDirection = HTPopoverViewCloseDirectionFromCenter;
    self.closable = NO;
    
    [self createAlertView];
}

- (void)createAlertView {
    CGFloat height = 0;
    UIFont *messageFont = kAppFontBold(18);
    if (![NSString isNullOrEmpty:_title]) {
        HTLabel *titleLabel = [self createLabelWithText:_title withFont:messageFont];
        [self addSubview: titleLabel];
        messageFont = kAppFont(14);
        height = CGRectGetMaxY(titleLabel.frame);
    }
    
    if (![NSString isNullOrEmpty:_message]) {
        HTLabel *messageLabel = [self createLabelWithText:_message withFont:messageFont];
        [self addSubview:messageLabel];
        messageLabel.y = MAX(height, 16);
        height = CGRectGetMaxY(messageLabel.frame) + 16;
    }
    if (_customView) {
        CGFloat customHeight = kDeviceHeight - height - 64 - 44;
        _customView.x = (self.frame.size.width - _customView.frame.size.width) / 2;
        if (_customView.frame.size.height > customHeight) {
            HTScrollView *scrollView = [[HTScrollView alloc] initWithFrame:CGRectMake(0, MAX(height, 16), self.frame.size.width, customHeight)];
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, _customView.frame.size.height);
            [self addSubview:scrollView];
            [scrollView addSubview:_customView];
            height = CGRectGetMaxY(scrollView.frame) + 16;
        }
        else {
            _customView.y = MAX(height, 16);
            [self addSubview:_customView];
            height = CGRectGetMaxY(_customView.frame) + 16;
        }
    }
    height += 44;
    
    self.height = height;
    
    [self createActionButtons];
    
    // Create blur effect
    if (NSClassFromString(@"UIVisualEffectView") != nil) {
        self.backgroundColor = kClearColor;
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithFrame:self.bounds];
        effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        effectView.layer.cornerRadius = self.radius;
        effectView.layer.masksToBounds = YES;
        [self insertSubview:effectView atIndex:0];
    }
}

- (void)createActionButtons {
    CGFloat height = self.height;
    if (![NSString isNullOrEmpty:_title] || ![NSString isNullOrEmpty:_message] || _customView) {
        HTView *lineView = [[HTView alloc] initWithFrame:CGRectMake(0, height - 44.5, self.frame.size.width, 1.0 / kDeviceScale)];
        lineView.backgroundColor = kRGBA(0, 0, 0, 0.25);
        [self addSubview:lineView];
    }
    
    NSInteger buttonIndex = 0;
    if (![NSString isNullOrEmpty:_cancelButtonTitle]) {
        _cancelButton = [self createButtonWithTitle:_cancelButtonTitle atIndex:buttonIndex ++];
        _cancelButton.frame = CGRectMake(0, height - 44, self.frame.size.width, 44);
        [self addSubview:_cancelButton];
    }
    
    if (![NSString isNullOrEmpty:_okButtonTitle]) {
        _okButton = [self createButtonWithTitle:_okButtonTitle atIndex:buttonIndex ++];
        if (_cancelButton) {
            _okButton.frame = CGRectMake(self.frame.size.width / 2, height - 44, self.frame.size.width / 2, 44);
            _cancelButton.width = self.frame.size.width / 2;
        }
        else {
            _okButton.frame = CGRectMake(0, height - 44, self.frame.size.width, 44);
        }
        [self addSubview:_okButton];
    }
    
    if (_cancelButton && _okButton) {
        HTView *spliterView = [[HTView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, height - 44.5, 1.0 / kDeviceScale, 44.5)];
        spliterView.backgroundColor = kRGBA(0, 0, 0, 0.25);
        [self addSubview:spliterView];
    }
}

- (HTLabel *)createLabelWithText:(NSString *)text withFont:(UIFont *)font {
    HTLabel *titleLabel = [[HTLabel alloc] initWithFrame:CGRectMake(16, 0, self.frame.size.width - 16 * 2, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = text;
    titleLabel.font = font;
    
    [titleLabel sizeToFit];
    
    CGRect currentFrame = titleLabel.frame;
    currentFrame.size.width = self.frame.size.width -16 * 2;
    currentFrame.origin.y = 16;
    currentFrame.size.height = MIN(currentFrame.size.height, (kDeviceHeight - 44 - 16 * 2 - 64) / 2);
    titleLabel.frame = currentFrame;
    
    return titleLabel;
}

- (HTButton *)createButtonWithTitle:(NSString *)title atIndex:(NSInteger)buttonIndex {
    HTButton *button = [HTButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.frame.size.width, 44);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:kRGB(28, 142, 232) forState:UIControlStateNormal];
    button.tag = 10000 + buttonIndex;
    [button addTarget:self action:@selector(handleActionButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)handleActionButton:(HTButton *)sender {
    __weak HTAlertView *weakSelf = self;
    [self closeOnCompletion:^(HTPopoverView *popoverView) {
        if (weakSelf.clickButtonAtIndex) {
            weakSelf.clickButtonAtIndex(weakSelf, sender.tag - 10000);
        }
    }];
}

- (void)setActionEnabled:(BOOL)enabled atIndex:(NSInteger)buttonIndex {
    UIView *actionButton = [self viewWithTag:10000 + buttonIndex];
    if (actionButton && [actionButton isKindOfClass:[HTButton class]]) {
        ((HTButton *)actionButton).enabled = enabled;
    }
}

- (HTButton *)buttonAtIndex:(NSInteger)buttonIndex {
    UIView *actionButton = [self viewWithTag:10000 + buttonIndex];
    if (actionButton && [actionButton isKindOfClass:[HTButton class]]) {
        return (HTButton *)actionButton;
    }
    return nil;
}

@end
