//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTTextView : UITextView<UITextFieldDelegate>

{
    NSString *placeholder;
    UIColor *placeholderColor;

@private
    UILabel *placeHolderLabel;
}

@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

-(void)textChanged:(NSNotification *)notification;

@end
