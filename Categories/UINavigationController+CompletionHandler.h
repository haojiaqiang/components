//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UINavigationController (CompletionHandler)

- (void)popViewControllerAnimated:(BOOL)animated completion:(void (^)())completion;

@end
