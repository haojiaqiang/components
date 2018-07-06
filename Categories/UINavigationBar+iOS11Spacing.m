//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "UINavigationBar+iOS11Spacing.h"
#import <objc/runtime.h>
#import "Constants.h"

@implementation UINavigationBar (iOS11Spacing)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(layoutSubviews)
                                     swizzledSel:@selector(sx_layoutSubviews)];
    });
}

-(void)sx_layoutSubviews{
    [self sx_layoutSubviews];
    
    if (iOS11_OR_LATER) {//需要调节
        self.layoutMargins = UIEdgeInsetsZero;
        CGFloat space = 15;
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass(subview.class) containsString:@"ContentView"]) {
                subview.layoutMargins = UIEdgeInsetsMake(0, space, 0, space);//可修正iOS11之后的偏移
                break;
            }
        }
    }
}

+ (void)swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Method originAddObserverMethod = class_getInstanceMethod(self, oriSel);
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, swiSel);
    
    [self swizzleMethodWithOriginSel:oriSel oriMethod:originAddObserverMethod swizzledSel:swiSel swizzledMethod:swizzledAddObserverMethod class:self];
}

+ (void)swizzleMethodWithOriginSel:(SEL)oriSel
                         oriMethod:(Method)oriMethod
                       swizzledSel:(SEL)swizzledSel
                    swizzledMethod:(Method)swizzledMethod
                             class:(Class)cls {
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}

@end
