//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTCounterView.h"
#import "HTButton.h"
#import "HTTextField.h"
#import "Constants.h"

@implementation HTCounterView
{
    HTButton *_decreaseButton, *_increaseButton;
    HTTextField *_numberField;
}

- (void)loadSubviews {
    [super loadSubviews];
    _step = 1;
    _minValue = 1;
    _maxValue = INT_MAX;
    _value = _minValue;
    self.radius = 3.0f;
    self.backgroundColor = kRGB(225, 225, 225);
    
    self.layer.cornerRadius = _radius;
    self.layer.borderColor = kRGB(225, 225, 225).CGColor;
    self.layer.borderWidth = 1.0f;
    
    _numberField = [[HTTextField alloc] init];
    _numberField.textAlignment = NSTextAlignmentCenter;
    _numberField.backgroundColor = kWhiteColor;
    _numberField.keyboardType = UIKeyboardTypeNumberPad;
    _numberField.inputAccessoryView = [self createInputAccessoryView];
    [self addSubview:_numberField];
    
    _decreaseButton = [HTButton buttonWithType:UIButtonTypeCustom];
    _decreaseButton.ltRadius = _decreaseButton.lbRadius = _radius;
    _decreaseButton.backgroundColor = kWhiteColor;
    [_decreaseButton setBackgroundColor:kWhiteColor forState:UIControlStateDisabled];
    _decreaseButton.titleLabel.font = kAppFontBold(18);
    [_decreaseButton setTitle:@"-" forState:UIControlStateNormal];
    [_decreaseButton setTitleColor:kRGB(55, 55, 55) forState:UIControlStateNormal];
    [_decreaseButton addTarget:self action:@selector(handleDecreaseNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_decreaseButton];
    
    _increaseButton = [HTButton buttonWithType:UIButtonTypeCustom];
    _increaseButton.rtRadius = _increaseButton.rbRadius = _radius;
    _increaseButton.backgroundColor = kWhiteColor;
    [_increaseButton setBackgroundColor:kWhiteColor forState:UIControlStateDisabled];
    _increaseButton.titleLabel.font = kAppFontBold(18);
    [_increaseButton setTitle:@"+" forState:UIControlStateNormal];
    [_increaseButton setTitleColor:kRGB(55, 55, 55) forState:UIControlStateNormal];
    [_increaseButton addTarget:self action:@selector(handleIncreaseNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_increaseButton];
    
    [self layout];
    [self setNumber:_value];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextChange:) name:UITextFieldTextDidChangeNotification object:_numberField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (HTView*) createInputAccessoryView{
    HTView *accessoryView = [[HTView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44) andRadius:0];
    accessoryView.backgroundColor = kRGB(215, 215, 215);
    HTButton *doneButton = [HTButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:kStr(@"Done") forState:UIControlStateNormal];
    doneButton.titleLabel.font = kAppFont(14);
    doneButton.frame = CGRectMake(accessoryView.frame.size.width-60-5, 5, 60, accessoryView.frame.size.height-5*2);
    doneButton.radius = 3.0f;
    doneButton.backgroundColor = kWhiteColor;
    doneButton.layer.cornerRadius = doneButton.radius;
    doneButton.layer.borderWidth = 1.0f;
    [doneButton addTarget:self action:@selector(handleNumberDone:) forControlEvents:UIControlEventTouchUpInside];
    [accessoryView addSubview:doneButton];
    return accessoryView;
}

- (void) handleNumberDone:(HTButton*) sender{
    [_numberField resignFirstResponder];
}

- (void) handleKeyboardShow:(NSNotification*) notification{
    CGSize kSize = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    kSize.height += 44;
    [self handleKeyboard:YES size:kSize];
}

- (void) handleKeyboardHide:(NSNotification*) notification{
    //CGSize kSize = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self handleKeyboard:NO size:CGSizeZero];
}

- (void) handleKeyboard:(BOOL) show size:(CGSize) keyboardSize{
    if (self.onKeyboardShow){
        self.onKeyboardShow(show, keyboardSize);
    }
}

- (BOOL) becomeFirstResponder{
    [_numberField becomeFirstResponder];
    return [super becomeFirstResponder];
}

- (BOOL) resignFirstResponder{
    [_numberField resignFirstResponder];
    return [super resignFirstResponder];
}

- (void) handleDecreaseNumber:(HTButton*) sender{
    if(_value>_minValue){
        _value--;
        [self setNumber:_value];
    }
}

- (void) handleIncreaseNumber:(HTButton*) sender{
    if(_value<_maxValue){
        _value++;
        [self setNumber:_value];
    }
}

- (void) handleTextChange:(NSNotification*) notification{
    int value = [_numberField.text intValue];
    if (value<_minValue) {
        value = _minValue;
    }
    else if(value>_maxValue){
        value = _maxValue;
    }
    [self setNumber:value];
}

- (void) removeFromSuperview{
    self.onKeyboardShow = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_numberField];
    [super removeFromSuperview];
}

- (void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self layout];
}

- (void) layout{
    int bw = MIN((int)self.frame.size.width/3, self.frame.size.height);
    _decreaseButton.frame = CGRectMake(0, 0, bw-1, self.frame.size.height);
    _increaseButton.frame = CGRectMake(self.frame.size.width-bw+1, 0, bw-1, self.frame.size.height);
    _numberField.frame = CGRectMake(bw, 0, self.frame.size.width-bw*2, self.frame.size.height);
}

- (void) setNumber:(int) value{
    _value = value;
    _numberField.text = [NSString stringWithFormat:@"%d", value];
    _decreaseButton.enabled = _value>_minValue;
    _increaseButton.enabled = _value<_maxValue;
}

- (void) setValue:(int)value{
    [self setNumber:value];
}

- (int) value{
    return _value;
}

- (void) setStep:(int)step{
    _step = step;
}

- (int) step{
    return _step;
}

- (void) setMinValue:(int)minValue{
    _minValue = minValue;
    if (_value<_minValue) {
        _value = _minValue;
        [self setNumber:_value];
    }
}

- (void) setMaxValue:(int)maxValue{
    _maxValue = maxValue;
    if (_value>_maxValue) {
        _value = _maxValue;
        [self setNumber:_value];
    }
}

- (int) minValue{
    return _minValue;
}

- (int) maxValue{
    return _maxValue;
}

@end
