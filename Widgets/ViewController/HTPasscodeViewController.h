//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTViewController.h"

@interface HTPasscodeViewController : HTViewController

@property (nonatomic, copy) void (^onFailed)();

@property (nonatomic, copy) void (^onSuccess)(NSString *passcode);

// Message show above passcode view
@property (nonatomic, copy) NSString *message;

// Times required for typing, default 1
@property (nonatomic, assign) NSInteger numbersOfType;

// Passcode length default 6
@property (nonatomic, assign) NSInteger passcodeLength;

// Check passcode is valid at type count index
- (BOOL) isValidPasscode:(NSString*) passcode atIndex:(NSInteger) index;

- (void) resetWithTypeCount:(NSInteger) typeCount;

- (void) clear;

- (void) hideKeyBoard;

@end
