//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HTTextFieldPlaceholderAlignment) {
    HTTextFieldPlaceholderAlignmentLeft,
    HTTextFieldPlaceholderAlignmentCenter,
    HTTextFieldPlaceholderAlignmentRight,
};

@interface HTTextField : UITextField

@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, assign) HTTextFieldPlaceholderAlignment placeholderAlilgnment;

@end
