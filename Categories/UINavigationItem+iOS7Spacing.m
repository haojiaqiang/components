//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "UINavigationItem+iOS7Spacing.h"
#import <objc/runtime.h>
#import "Constants.h"

#define xSpacerWidth -8

@implementation UINavigationItem (iOS7Spacing)

- (UIBarButtonItem *)spacer
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = xSpacerWidth;
    return space;
}

- (void)mk_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    if (iOS11_OR_LATER) {
        [self mk_setLeftBarButtonItem:leftBarButtonItem];
    } else if (iOS7_OR_LATER) {
        if (leftBarButtonItem && (leftBarButtonItem.customView !=nil || leftBarButtonItem.image !=nil)) {
            [self mk_setLeftBarButtonItem:nil];
            [self mk_setLeftBarButtonItems:@[[self spacer], leftBarButtonItem]];
        } else {
            if (iOS7_OR_LATER) {
                [self mk_setLeftBarButtonItems:nil];
            }
            [self mk_setLeftBarButtonItem:leftBarButtonItem];
        }
    } else {
        [self mk_setLeftBarButtonItem:leftBarButtonItem];
    }
}

- (void)mk_setLeftBarButtonItems:(NSArray *)leftBarButtonItems
{
    if (iOS7_OR_LATER && leftBarButtonItems && leftBarButtonItems.count > 0 ) {
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:leftBarButtonItems.count + 1];
        [items addObject:[self spacer]];
        [items addObjectsFromArray:leftBarButtonItems];
        
        [self mk_setLeftBarButtonItems:items];
    } else {
        [self mk_setLeftBarButtonItems:leftBarButtonItems];
    }
}

- (void)mk_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    if (iOS11_OR_LATER) {
        [self mk_setRightBarButtonItem:rightBarButtonItem];
    } else if (iOS7_OR_LATER) {
        if (rightBarButtonItem && (rightBarButtonItem.customView !=nil || rightBarButtonItem.image != nil)) {
            [self mk_setRightBarButtonItem:nil];
            [self mk_setRightBarButtonItems:@[[self spacer], rightBarButtonItem]];
        } else {
            if (iOS7_OR_LATER) {
                [self mk_setRightBarButtonItems:nil];
            }
            [self mk_setRightBarButtonItem:rightBarButtonItem];
        }
    } else {
        [self mk_setRightBarButtonItem:rightBarButtonItem];
    }
}

- (void)mk_setRightBarButtonItems:(NSArray *)rightBarButtonItems
{
    if (iOS7_OR_LATER && rightBarButtonItems && rightBarButtonItems.count > 0) {
        
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:rightBarButtonItems.count + 1];
        [items addObject:[self spacer]];
        [items addObjectsFromArray:rightBarButtonItems];
        
        [self mk_setRightBarButtonItems:items];
    } else {
        [self mk_setRightBarButtonItems:rightBarButtonItems];
    }
}

+ (void)mk_swizzle:(SEL)aSelector
{
    SEL bSelector = NSSelectorFromString([NSString stringWithFormat:@"mk_%@", NSStringFromSelector(aSelector)]);
    
    Method m1 = class_getInstanceMethod(self, aSelector);
    Method m2 = class_getInstanceMethod(self, bSelector);
    
    method_exchangeImplementations(m1, m2);
}

+ (void)load
{
    [self mk_swizzle:@selector(setLeftBarButtonItem:)];
    [self mk_swizzle:@selector(setLeftBarButtonItems:)];
    [self mk_swizzle:@selector(setRightBarButtonItem:)];
    [self mk_swizzle:@selector(setRightBarButtonItems:)];
}

@end
