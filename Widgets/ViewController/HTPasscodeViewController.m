//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTPasscodeViewController.h"
#import "HTView.h"
#import "HTLabel.h"
#import "Constants.h"
#import "HTAppConstants.h"
#import "HTColor.h"

@interface HTPasscodeViewController ()

@end

@implementation HTPasscodeViewController
{
    NSInteger _numbersOfType;
    NSInteger _passcodeLength;
    NSString *_message;
    
    NSMutableArray *_passcodes;
    NSMutableArray *_passcodeViews;
    
    UITextField *_passcodeField;
    
    HTView *_contentView;
    HTLabel *_messageLabel;
}

static NSString *BulletCharacter = @"\u25CF";

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_passcodeField becomeFirstResponder];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_passcodeField resignFirstResponder];
}

- (void) dealloc {
    self.onSuccess = nil;
    self.onFailed = nil;
#if !__has_feature(objc_arc)
    [super dealloc]
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentView = [[HTView alloc] initWithFrame:self.view.bounds];
    _contentView.layer.masksToBounds = YES;
    [self.view addSubview:_contentView];
    if (_numbersOfType==0) {
        _numbersOfType = 1;
    }
    if (_passcodeLength==0) {
        _passcodeLength = 6;
    }
    
    _passcodes = [NSMutableArray array];
    
    _passcodeField = [[UITextField alloc] init];
    _passcodeField.hidden = YES;
    _passcodeField.keyboardType = UIKeyboardTypeNumberPad;
    [_passcodeField addTarget:self action:@selector(handlePasscodeChange:) forControlEvents:UIControlEventEditingChanged];
    [_contentView addSubview:_passcodeField];
    
    _passcodeViews = [NSMutableArray array];
    [self createPasscodeViews];
    
    _messageLabel = [[HTLabel alloc] initWithFrame:CGRectMake(0, 66+64, self.view.frame.size.width, 34)];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.font = kAppFont(14);
    _messageLabel.text = _message;
    _messageLabel.textColor = [HTColor grayForTitleText];
    [_contentView addSubview:_messageLabel];
    
}

- (void) resetWithTypeCount:(NSInteger)typeCount {
    _numbersOfType = MAX(typeCount, 1);
    for (HTView *passcodeView in _passcodeViews) {
        [passcodeView removeFromSuperview];
    }
    [_passcodeViews removeAllObjects];
    [_passcodes removeAllObjects];
    _passcodeField.text = @"";
    [self createPasscodeViews];
}

- (void) createPasscodeViews {
    for (NSInteger i=0;i<_numbersOfType;++i) {
        HTView *passcodeView = [self createPasscodeView];
        [_contentView addSubview:passcodeView];
        CGRect r = passcodeView.frame;
        r.origin.x += i*self.view.frame.size.width;
        passcodeView.frame = r;
        [_passcodeViews addObject:passcodeView];
    }
}

- (void) resetPasscodeViews {
    for (HTView *passcodeView in _passcodeViews) {
        for (UIView *v in passcodeView.subviews) {
            if ([v isKindOfClass:[HTLabel class]]) {
                ((HTLabel*)v).text = @"";
            }
        }
    }
    [_passcodes removeAllObjects];
    _passcodeField.text = @"";
}

- (void) clear {
    [self resetPasscodeViews];
}

- (HTView*) createPasscodeView {
    CGFloat width = 45;
    CGFloat spacing = 0.5;
    CGFloat borderWidth = 0.5;
    CGFloat w = width*_passcodeLength+(_passcodeLength-1)*spacing+borderWidth*2;
    HTView *passcodeView = [[HTView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-w)/2, 100+64, w, width) andRadius:0];
    passcodeView.backgroundColor = kRGB(225, 225, 225);
    passcodeView.layer.borderColor = HTAppBaseColor.CGColor;
    passcodeView.layer.borderWidth = borderWidth;
    passcodeView.layer.cornerRadius = passcodeView.radius;
    
    for (NSInteger i=0;i<_passcodeLength;++i) {
        HTLabel *label = [[HTLabel alloc] initWithFrame:CGRectMake(i*(width+spacing)+borderWidth, 0, width, width)];
        label.backgroundColor = kWhiteColor;
        label.textColor = kBlackColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kAppFontBold(22);
        [passcodeView addSubview:label];
    }
    return passcodeView;
}

- (void) setNumbersOfType:(NSInteger)numbersOfType {
    _numbersOfType = MAX(numbersOfType, 1);
}

- (void) setPasscodeLength:(NSInteger)passcodeLength {
    _passcodeLength = MAX(passcodeLength, 1);
}

- (void) setMessage:(NSString *)message {
    _message = message;
    if (_messageLabel) {
        _messageLabel.text = message;
    }
}

- (void) handlePasscodeChange:(UITextField*) textField {
    NSInteger len = textField.text.length;
    HTView *passcodeView = [_passcodeViews objectAtIndex:MIN(_passcodes.count, _numbersOfType-1)];
    for (NSInteger i=0;i<_passcodeLength;++i) {
        HTLabel *label = [passcodeView.subviews objectAtIndex:i];
        if (i<len) {
            label.text = BulletCharacter;
        }
        else {
            label.text = @"";
        }
    }
    if (len>_passcodeLength) {
        _passcodeField.text = [_passcodeField.text substringToIndex:_passcodeLength];
    }
    if (len<_passcodeLength) {
        //Type tot complete
        if(_passcodes.count==_numbersOfType) {
            // Remove at index _numberOfType-1
            [_passcodes removeLastObject];
        }
    }
    if (len==_passcodeLength) {
        NSString *passcode = _passcodeField.text;
        BOOL passed = [self isValidPasscode:passcode atIndex:_passcodes.count];
        if (!passed) {
            if (_passcodes.count>0) {
                [self moveForward:-self.view.frame.size.width*_passcodes.count];
            }
            [self resetPasscodeViews];
            if (self.onFailed) {
                self.onFailed();
            }
        }
        else {
            [_passcodes addObject:_passcodeField.text];
            if (_passcodes.count<_numbersOfType) {
                [self moveForward:self.view.frame.size.width];
            }
        }
        
        if (passed && _passcodes.count==_numbersOfType) {
            if (self.onSuccess) {
                self.onSuccess(_passcodeField.text);
            }
        }
    }
}

- (void) moveForward:(CGFloat) moveX {
    _passcodeField.text = @"";
    for (HTView *passcodeView in _passcodeViews) {
        CGRect r = passcodeView.frame;
        r.origin.x -= moveX;
        [UIView animateWithDuration:0.25 animations:^{
            passcodeView.frame = r;
        } completion:^(BOOL finished) {
            [self handleTypeCount:_passcodes.count];
        }];
    }
}

- (BOOL) isValidPasscode:(NSString*) passcode atIndex:(NSInteger) index {
    if (index>0) {
        NSString *lastPasscode = _passcodes.lastObject;
        if (![lastPasscode isEqualToString:passcode]) {
            return NO;
        }
    }
    return YES;
}

- (void) handleTypeCount:(NSInteger) typeCount {}

- (void) hideKeyBoard {
    [_passcodeField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
