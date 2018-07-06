//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTRefreshIndicator.h"

typedef NS_ENUM(NSInteger, HTRefreshState) {
    HTRefreshStateUnknown = -1,
    HTRefreshStateNormal,
    HTRefreshStateReadyToRefresh,
    HTRefreshStateRefreshing,
};

@interface HTRefreshView : UIView
{
    // Scroll view to be pulling refresh
    __weak UIScrollView *_scrollView;
    
    // Indicator
    __unsafe_unretained id<HTRefreshIndicator> _indicator;
    
    // Refresh state
    HTRefreshState _state;
    
    // Scroll view original content inset
    UIEdgeInsets _originalContentInset;
    
    // Refresh inset height added when refreshing
    CGFloat _refreshInsetHeight;
}

@property (nonatomic, assign) HTRefreshState state;

// Pulling refresh view
@property (nonatomic, assign, readonly) UIScrollView *scrollView;

// Refresh indicator view
@property (nonatomic, assign) id<HTRefreshIndicator> indicator;

@end

@interface HTRefreshHeaderView : HTRefreshView

@end

@interface HTRefreshFooterView : HTRefreshView

@end
