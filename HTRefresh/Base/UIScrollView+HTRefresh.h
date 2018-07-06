//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTRefreshView.h"
#import "HTRefreshIndicator.h"

@interface UIScrollView (HTRefresh)

// Set refresh Header indicator
- (void)setRefreshHeaderIndicator:(id<HTRefreshIndicator>)indicator;

// Set refresh Header with indicator class
- (void)setRefreshHeaderWithIndicatorClass:(Class)clazz;

// Set refresh Footer indicator
- (void)setRefreshFooterIndicator:(id<HTRefreshIndicator>)indicator;

// Set refresh Footer with indicator class
- (void)setRefreshFooterWithIndicatorClass:(Class)clazz;

// Stop Header Refreshing
- (void)stopHeaderRefreshing;

// Stop Footer Refreshing
- (void)stopFooterRefreshing;

// Header Refresing
- (void)refreshHeader;

// Footer Refresing
- (void)refreshFooter;

// Set refresh enabled, sometimes you need to switch refreshable state
- (void)setRefreshEnabled:(BOOL)refreshEnabled;

// Set refresh enabled, sometimes you need to switch refreshable state
- (void)setRefreshHeaderEnabled:(BOOL)refreshEnabled;

// Get state of refresh header enabled
- (BOOL)refreshHeaderEnabled;

// Set refresh enabled, sometimes you need to switch refreshable state
- (void)setRefreshFooterEnabled:(BOOL)refreshEnabled;

// Get state of refresh footer enabled
- (BOOL)refreshFooterEnabled;

// Refresh header callback
- (void)setRefreshHeaderCallback:(void (^)())refreshHeaderCallback;

// Refresh footer callback
- (void)setRefreshFooterCallback:(void (^)())refreshFooterCallback;

// Refresh header state
- (HTRefreshState)refreshHeaderState;

// Refresh footer state
- (HTRefreshState)refreshFooterState;

@end
