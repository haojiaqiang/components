//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTRefreshView.h"
#import "UIScrollView+HTRefresh.h"

static NSString *HTRefreshContentOffsetKeyPath = @"contentOffset";
static NSString *HTRefreshContentInsetKeyPath = @"contentInset";
static NSString *HTRefreshContentSizeKeyPath = @"contentSize";
static NSString *HTRefreshFrameKeyPath = @"frame";

static CGFloat HTRefreshHeaderViewHeight = 54;
static CGFloat HTRefreshFooterViewHeight = 49;

@interface HTRefreshView ()
// Refresh state, indicator
- (void)setState:(HTRefreshState)state;
- (void)setIndicator:(id<HTRefreshIndicator>)indicator;

// Content inset
- (void)addRefreshContentInset:(BOOL)animated;
- (void)removeRefreshContentInset:(BOOL)animated;

- (void)layout;

// Observer handles
- (void)contentOffsetChanged:(NSDictionary *)change;
- (void)contentInsetChanged:(NSDictionary *)change;
- (void)contentSizeChanged:(NSDictionary *)change;
- (void)contentFrameChanged:(NSDictionary *)change;
@end

// Observers
@interface HTRefreshView (ObserverMethods)
- (void)addObservers;
- (void)removeObservers;
@end

@implementation HTRefreshView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layout];
}

- (UIScrollView *)scrollView {
    return _scrollView;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // Call super method
    [super willMoveToSuperview:newSuperview];
    
    // Check super view tye
    if (!newSuperview || ![newSuperview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    
    _scrollView = (UIScrollView *)newSuperview;
    
    // Work around, just get the correct original content inset
    [self performSelector:@selector(initOriginalContentInset) withObject:nil afterDelay:0.01];
    
    CGRect r = self.frame;
    r.origin.x = 0;
    r.size.width = newSuperview.frame.size.width;
    self.frame = r;
    
    // If has super view
    if (self.superview) {
        [self removeObservers];
    }
    
    // Add required observers
    [self addObservers];
}

- (void)initOriginalContentInset {
    _originalContentInset = _scrollView.contentInset;
}

- (void)removeFromSuperview {
    [self removeObservers];
    [super removeFromSuperview];
}

- (void)setIndicator:(id<HTRefreshIndicator>)indicator {
    if(_indicator != indicator) {
        if (_indicator && [_indicator isKindOfClass:[UIView class]]) {
            [((UIView *)_indicator) removeFromSuperview];
            _indicator = nil;
        }
        _indicator = indicator;
        if ([indicator isKindOfClass:[UIView class]]) {
            [self addSubview:(UIView *)indicator];
        }
    }
}

- (void)setState:(HTRefreshState)state {
    if (state == _state) {
        return;
    }
    _state = state;
    if (state == HTRefreshStateRefreshing) {
        _refreshInsetHeight = self.frame.size.height;
        
        // Set content inset
        [self addRefreshContentInset:YES];
        
        if ([_indicator respondsToSelector:@selector(pullingWithRatio:)]) {
            [_indicator pullingWithRatio:1.0];
        }
        
        // Start indicator
        if ([_indicator respondsToSelector:@selector(start)]) {
            [_indicator start];
        }
    }
    else if (state == HTRefreshStateNormal) {
        // Set content inset
        [self removeRefreshContentInset:YES];
        
        // Start indicator
        if ([_indicator respondsToSelector:@selector(stop)]) {
            [_indicator stop];
        }
    }
}


// Override by sub classes
- (void)addRefreshContentInset:(BOOL)animated {
    // Realization in sub class
}

- (void)removeRefreshContentInset:(BOOL)animated {
    // Realization in sub class
}

- (void)layout {
    // Realization in sub class
}

- (void)contentOffsetChanged:(NSDictionary *)change {
    // Realization in sub class
}

- (void)contentInsetChanged:(NSDictionary *)change {
    [self layout];
}

- (void)contentSizeChanged:(NSDictionary *)change {
    [self layout];
}

- (void)contentFrameChanged:(NSDictionary *)change {
    // Realization in sub class
}

@end

@implementation HTRefreshView (ObserverMethods)

- (void)addObservers {
    [_scrollView addObserver:self forKeyPath:HTRefreshContentOffsetKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:HTRefreshContentInsetKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:HTRefreshContentSizeKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:HTRefreshFrameKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:HTRefreshContentOffsetKeyPath];
    [self.superview removeObserver:self forKeyPath:HTRefreshContentInsetKeyPath];
    [self.superview removeObserver:self forKeyPath:HTRefreshContentSizeKeyPath];
    [self.superview removeObserver:self forKeyPath:HTRefreshFrameKeyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([HTRefreshContentOffsetKeyPath isEqualToString:keyPath]) {
        [self contentOffsetChanged:change];
    }
    else if ([HTRefreshContentInsetKeyPath isEqualToString:keyPath]) {
        [self contentInsetChanged:change];
    }
    else if ([HTRefreshContentSizeKeyPath isEqualToString:keyPath]) {
        [self contentSizeChanged:change];
    }
    else if ([HTRefreshFrameKeyPath isEqualToString:keyPath]) {
        [self contentFrameChanged:change];
    }
}

@end

#pragma refresh header view
@implementation HTRefreshHeaderView
{
    int _flag; // This flag just do .... work around flag
}

- (void)contentOffsetChanged:(NSDictionary *)change {
    // Call super method
    [super contentOffsetChanged:change];
    
    // Check refresh state
    if (_state==HTRefreshStateRefreshing) {
        [self adjustContentInset];
        return;
    }
    
    // Correct content inset firstly set here, assignment in willMoveToSuperView not work infact
    //_originalContentInsets = _scrollView.contentInset;
    
    CGPoint contentOffset = _scrollView.contentOffset;
    if (_scrollView.isDragging) {
        CGFloat ratio = 0;
        BOOL invokeRatio = NO;
        CGFloat offsetY = contentOffset.y + _originalContentInset.top;
        if (offsetY<=-self.frame.size.height) {
            _state = HTRefreshStateReadyToRefresh;
        }
        else {
            _state = HTRefreshStateNormal;
        }
        if (offsetY<0) {
            ratio = MAX(0, MIN(-offsetY / self.frame.size.height, 1.0));
            invokeRatio = YES;
        }
        if (invokeRatio && [_indicator respondsToSelector:@selector(pullingWithRatio:)]) {
            [_indicator pullingWithRatio:ratio];
        }
    }
    else {
        if (_state==HTRefreshStateReadyToRefresh) {
            [_scrollView refreshHeader];
        }
    }
}

- (void)adjustContentInset {
    if (_flag>0) {
        return;
    }
    // Fix: A known issue here, when table view with section header, and scroll up, a gap between top and section header
    CGPoint contentOffset = _scrollView.contentOffset;
    if (contentOffset.y > -_originalContentInset.top - _refreshInsetHeight) {
        UIEdgeInsets inset = _scrollView.contentInset;
        _refreshInsetHeight = - MIN((contentOffset.y + _originalContentInset.top), 0);
        inset.top = _originalContentInset.top +_refreshInsetHeight;
        _scrollView.contentInset = inset;
    }
    else {
        UIEdgeInsets inset = _scrollView.contentInset;
        _refreshInsetHeight = MIN(-(contentOffset.y + _originalContentInset.top), self.frame.size.height);
        inset.top = _originalContentInset.top +_refreshInsetHeight;
        _scrollView.contentInset = inset;
    }
}

- (void)contentFrameChanged:(NSDictionary *)change {
    _flag = 2;
}

- (void)contentInsetChanged:(NSDictionary *)change {
    if (_state != HTRefreshStateRefreshing) {
        _flag = 1;
        _originalContentInset = _scrollView.contentInset;
    }
    else {
        if (_flag > 0) {
            _flag --;
            _originalContentInset.top = _scrollView.contentInset.top - _refreshInsetHeight;
        }
    }
    [super contentInsetChanged:change];
}

- (void)contentSizeChanged:(NSDictionary *)change {
    [super contentSizeChanged:change];
}

- (void)addRefreshContentInset:(BOOL)animated {
    UIEdgeInsets edgeInset = _scrollView.contentInset;
    edgeInset.top = _refreshInsetHeight + _originalContentInset.top;
    CGFloat duration = animated? 0.25 : 0;
    [UIView animateWithDuration:duration animations:^{
        _scrollView.contentInset = edgeInset;
        _scrollView.contentOffset = CGPointMake(0, -edgeInset.top);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeRefreshContentInset:(BOOL)animated {
    UIEdgeInsets edgeInset = _scrollView.contentInset;
    // Fix inset issue, when scroll view is refresh, and push another view controller
    edgeInset.top -= _refreshInsetHeight;//=_originalContentInsets.top;
    _refreshInsetHeight = 0;
    CGFloat duration = animated? 0.25 : 0;
    [UIView animateWithDuration:duration animations:^{
        _scrollView.contentInset = edgeInset;
    } completion:^(BOOL finished) {
        _flag = 0;
        if ([_indicator respondsToSelector:@selector(reset)]) {
            [_indicator reset];
        }
    }];
}

- (void)layout {
    CGRect r = self.frame;
    CGFloat indicatorHeight = 0;
    if ([_indicator respondsToSelector:@selector(indicatorHeight)]) {
        if ([_indicator indicatorHeight] > 0) {
            indicatorHeight = [_indicator indicatorHeight];
        }
    }
    if (indicatorHeight <= 0) {
        indicatorHeight = HTRefreshHeaderViewHeight;
    }
    r.size.height = indicatorHeight;
    r.origin.y = -r.size.height;
    self.frame = r;
    if (_indicator) {
        ((UIView*)_indicator).frame = self.bounds;
    }
}

@end

#pragma refresh footer view
@implementation HTRefreshFooterView

- (void)contentOffsetChanged:(NSDictionary *)change {
    
    // Call super method
    [super contentOffsetChanged:change];
    
    // Check refresh state
    if (_state == HTRefreshStateRefreshing) {
        return;
    }
    
    // Correct content inset firstly set here, assignment in willMoveToSuperView not work infact
    //_originalContentInsets = _scrollView.contentInset;
    
    CGPoint contentOffset = _scrollView.contentOffset;
    if (_scrollView.isDragging) {
        CGFloat ratio = 0;
        BOOL invokeRatio = NO;
        CGFloat offsetY = contentOffset.y + _originalContentInset.top;
        CGFloat beginY = MAX(_scrollView.contentSize.height - _scrollView.frame.size.height + _originalContentInset.top + _originalContentInset.bottom, 0);
        if (offsetY >= beginY + self.frame.size.height) {
            _state = HTRefreshStateReadyToRefresh;
        }
        else {
            _state = HTRefreshStateNormal;
        }
        if (offsetY > beginY) {
            ratio = MAX(0, MIN((offsetY - beginY) / self.frame.size.height, 1.0));
            invokeRatio = YES;
        }
        if (invokeRatio && [_indicator respondsToSelector:@selector(pullingWithRatio:)]) {
            [_indicator pullingWithRatio:ratio];
        }
    }
    else {
        if (_state == HTRefreshStateReadyToRefresh) {
            [_scrollView refreshFooter];
        }
    }
}

- (void)contentInsetChanged:(NSDictionary *)change {
    /*
     if (_state!=HTRefreshStateRefreshing) {
     _originalContentInset = _scrollView.contentInset;
     }
     else {
     CGFloat top = _originalContentInset.top;
     CGFloat bottom = _originalContentInset.bottom;
     
     _originalContentInset.bottom = _scrollView.contentInset.bottom;
     _originalContentInset.bottom -= self.frame.size.height;
     
     // If scroll view content size height less than it's frame
     _originalContentInset.bottom -= MAX(_scrollView.frame.size.height-top-bottom-_scrollView.contentSize.height, 0);
     }*/
    [super contentInsetChanged:change];
}

- (void)contentSizeChanged:(NSDictionary *)change {
    [super contentSizeChanged:change];
}

- (void)addRefreshContentInset:(BOOL)animated {
    UIEdgeInsets edgeInset = _scrollView.contentInset;
    edgeInset.bottom = _refreshInsetHeight + _originalContentInset.bottom + MAX(_scrollView.frame.size.height - _originalContentInset.top - _originalContentInset.bottom - _scrollView.contentSize.height, 0);
    CGFloat duration = animated? 0.25 : 0;
    [UIView animateWithDuration:duration animations:^{
        _scrollView.contentInset = edgeInset;
    } completion:^(BOOL finished) {
    }];
}

- (void)removeRefreshContentInset:(BOOL)animated {
    UIEdgeInsets edgeInset = _scrollView.contentInset;
    // Fix inset issue, when scroll view is refresh, and push another view controller
    edgeInset.bottom -= _refreshInsetHeight;//=_originalContentInsets.bottom;
    _refreshInsetHeight = 0;
    
    // If scroll view content size height less than it's frame
    edgeInset.bottom -= MAX(_scrollView.frame.size.height - _originalContentInset.top - _originalContentInset.bottom - _scrollView.contentSize.height, 0);
    
    CGFloat duration = animated? 0.25 : 0;
    [UIView animateWithDuration:duration animations:^{
        _scrollView.contentInset = edgeInset;
    } completion:^(BOOL finished) {
        if ([_indicator respondsToSelector:@selector(reset)]) {
            [_indicator reset];
        }
    }];
}

- (void)layout {
    CGRect r = self.frame;
    CGFloat indicatorHeight = 0;
    if ([_indicator respondsToSelector:@selector(indicatorHeight)]) {
        if ([_indicator indicatorHeight] > 0) {
            indicatorHeight = [_indicator indicatorHeight];
        }
    }
    if (indicatorHeight <= 0) {
        indicatorHeight = HTRefreshFooterViewHeight;
    }
    r.size.height = indicatorHeight;
    r.origin.y = MAX(_scrollView.contentSize.height, _scrollView.frame.size.height - _originalContentInset.top - _originalContentInset.bottom);
    self.frame = r;
    if (_indicator) {
        ((UIView *)_indicator).frame = self.bounds;
    }
}

@end
