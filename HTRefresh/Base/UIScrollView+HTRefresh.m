//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2018年 Hayato. All rights reserved.
//

#import "UIScrollView+HTRefresh.h"
#import <objc/runtime.h>

@interface UIScrollView ()
@property (nonatomic, strong) HTRefreshView *header;
@property (nonatomic, strong) HTRefreshView *footer;
@property (nonatomic, copy) void (^refreshHeaderCallback)();
@property (nonatomic, copy) void (^refreshFooterCallback)();
@end

static const NSString *HTRefreshHeaderKey = @"HTRefreshHeaderView";
static const NSString *HTRefreshFooterKey = @"HTRefreshFooterView";
static const NSString *HTRefreshHeaderCallbackKey = @"HTRefreshHeaderViewCallback";
static const NSString *HTRefreshFooterCallbackKey = @"HTRefreshFooterViewCallback";

@implementation UIScrollView (HTRefresh)

- (void)setHeader:(HTRefreshView *)header {
    objc_setAssociatedObject(self, &HTRefreshHeaderKey, header, OBJC_ASSOCIATION_RETAIN);
}

- (void)setFooter:(HTRefreshView *)footer {
    objc_setAssociatedObject(self, &HTRefreshFooterKey, footer, OBJC_ASSOCIATION_RETAIN);
}

- (HTRefreshView *)header {
    return objc_getAssociatedObject(self, &HTRefreshHeaderKey);
}

- (HTRefreshView *)footer {
    return objc_getAssociatedObject(self, &HTRefreshFooterKey);
}

- (void)setRefreshHeaderCallback:(void (^)())refreshHeaderCallback {
    objc_setAssociatedObject(self, &HTRefreshHeaderCallbackKey, refreshHeaderCallback, OBJC_ASSOCIATION_COPY);
}

- (void)setRefreshFooterCallback:(void (^)())refreshFooterCallback {
    objc_setAssociatedObject(self, &HTRefreshFooterCallbackKey, refreshFooterCallback, OBJC_ASSOCIATION_COPY);
}

- (void(^)())refreshHeaderCallback {
    return objc_getAssociatedObject(self, &HTRefreshHeaderCallbackKey);
}

- (void(^)())refreshFooterCallback {
    return objc_getAssociatedObject(self, &HTRefreshFooterCallbackKey);
}

- (void)setRefreshHeaderWithIndicatorClass:(Class)clazz {
    if ([clazz conformsToProtocol:@protocol(HTRefreshIndicator)]) {
        id<HTRefreshIndicator> indicator = [[clazz alloc] init];
        [self setRefreshHeaderIndicator:indicator];
    }
}

- (void)setRefreshHeaderIndicator:(id<HTRefreshIndicator>)indicator {
    if (!self.header) {
        HTRefreshView *refreshView = [[HTRefreshHeaderView alloc] init];
        [self addSubview:refreshView];
        self.header = refreshView;
    }
    if (indicator) {
        [self.header setIndicator:indicator];
    }
}

- (void)setRefreshFooterWithIndicatorClass:(Class)clazz {
    if ([clazz conformsToProtocol:@protocol(HTRefreshIndicator)]) {
        id<HTRefreshIndicator> indicator = [[clazz alloc] init];
        [self setRefreshFooterIndicator:indicator];
    }
}

- (void)setRefreshFooterIndicator:(id<HTRefreshIndicator>)indicator {
    if (!self.footer) {
        HTRefreshView *refreshView = [[HTRefreshFooterView alloc] init];
        [self addSubview:refreshView];
        self.footer = refreshView;
    }
    if (indicator) {
        [self.footer setIndicator:indicator];
    }
}

- (void)refreshHeader {
    if (self.header) {
        BOOL refreshRequired = [self refreshHeaderState] != HTRefreshStateRefreshing;
        [self.header setState:HTRefreshStateRefreshing];
        if (refreshRequired) {
            if (self.refreshHeaderCallback) {
                self.refreshHeaderCallback();
            }
        }
    }
}

- (void)refreshFooter {
    if (self.footer) {
        BOOL refreshRequired = [self refreshFooterState] != HTRefreshStateRefreshing;
        [self.footer setState:HTRefreshStateRefreshing];
        if (refreshRequired) {
            if (self.refreshFooterCallback) {
                self.refreshFooterCallback();
            }
        }
    }
}

- (void)stopHeaderRefreshing {
    if (self.header) {
        [self.header setState:HTRefreshStateNormal];
    }
}

- (void)stopFooterRefreshing {
    if (self.footer) {
        [self.footer setState:HTRefreshStateNormal];
    }
}

- (void)setRefreshEnabled:(BOOL)refreshEnabled {
    [self setRefreshHeaderEnabled:refreshEnabled];
    [self setRefreshFooterEnabled:refreshEnabled];
}

- (void)setRefreshHeaderEnabled:(BOOL)refreshEnabled {
    if (refreshEnabled) {
        if (self.header && !self.header.superview) {
            [self addSubview:self.header];
        }
    }
    else {
        if (self.header && self.header.superview == self) {
            // If is refreshing, stop it to adjust content inset
            [self.header setState:HTRefreshStateNormal];
            
            // Remove from self
            [self.header removeFromSuperview];
        }
    }
}

- (BOOL)refreshHeaderEnabled {
    if (self.header && self.header.superview == self) {
        return YES;
    }
    return NO;
}

- (void)setRefreshFooterEnabled:(BOOL)refreshEnabled {
    if (refreshEnabled) {
        if (self.footer && !self.footer.superview) {
            [self addSubview:self.footer];
        }
    }
    else {
        if (self.footer && self.footer.superview == self) {
            // If is refreshing, stop it to adjust content inset
            [self.footer setState:HTRefreshStateNormal];
            
            // Remove from self
            [self.footer removeFromSuperview];
        }
    }
}

- (BOOL)refreshFooterEnabled {
    if (self.footer && self.footer.superview == self) {
        return YES;
    }
    return NO;
}

- (HTRefreshState)refreshHeaderState {
    if (self.header) {
        return self.header.state;
    }
    return HTRefreshStateUnknown;
}

- (HTRefreshState)refreshFooterState {
    if (self.footer) {
        return self.footer.state;
    }
    return HTRefreshStateUnknown;
}

@end
