//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2018年 Hayato. All rights reserved.
//

#import "TWRefreshTableView.h"
#import "LFRefreshIndicatorView.h"

@implementation TWRefreshTableView
{
    TWRefreshType _refreshType;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _refreshType = TWRefreshTypeTop|TWRefreshTypeBottom;
        [self prepareRefresh];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame refreshType:(TWRefreshType)refreshTpye {
    return [self initWithFrame:frame style:UITableViewStylePlain refreshType:refreshTpye];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle) style refreshType:(TWRefreshType)refreshType {
    self = [super initWithFrame:frame style:style];
    if (self) {
        _refreshType = refreshType;
        [self prepareRefresh];
    }
    return self;
}

- (void)setRefreshType:(TWRefreshType)refreshType {
    if (_refreshType != refreshType) {
        _refreshType = refreshType;
        [self prepareRefresh];
    }
}

- (void)prepareRefresh {
    if((_refreshType & TWRefreshTypeTop) == TWRefreshTypeTop){
        [self setRefreshHeaderWithIndicatorClass:[LFRefreshIndicatorView class]];
    }
    if((_refreshType & TWRefreshTypeBottom) == TWRefreshTypeBottom){
        [self setRefreshFooterWithIndicatorClass:[LFRefreshIndicatorView class]];
    }
}

- (void)refreshHeader {
    BOOL refreshRequired = [self refreshHeaderState] != TWRefreshStateRefreshing;
    [super refreshHeader];
    if (refreshRequired) {
        if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(beginRefreshHeader:)]) {
            [self.refreshDelegate beginRefreshHeader:self];
        }
    }
}

- (void)refreshFooter {
    BOOL refreshRequired = [self refreshFooterState] != TWRefreshStateRefreshing;
    [super refreshFooter];
    if (refreshRequired) {
        if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(beginRefreshFooter:)]) {
            [self.refreshDelegate beginRefreshFooter:self];
        }
    }
}

@end
