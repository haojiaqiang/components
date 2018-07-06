//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "UINavigationController+CompletionHandler.h"

@implementation UINavigationController (CompletionHandler)

- (void)popViewControllerAnimated:(BOOL)animated completion:(void (^)())completion {
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self popViewControllerAnimated:animated];
    [CATransaction commit];
}

@end
