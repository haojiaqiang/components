//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTRefreshTableView.h"
#import "HTRefreshIndicatorView.h"

@implementation HTRefreshTableView
{
    HTRefreshType _refreshType;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _refreshType = HTRefreshTypeTop|HTRefreshTypeBottom;
        [self prepareRefresh];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame refreshType:(HTRefreshType)refreshTpye {
    return [self initWithFrame:frame style:UITableViewStylePlain refreshType:refreshTpye];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle) style refreshType:(HTRefreshType)refreshType {
    self = [super initWithFrame:frame style:style];
    if (self) {
        _refreshType = refreshType;
        [self prepareRefresh];
    }
    return self;
}

- (void)setRefreshType:(HTRefreshType)refreshType {
    if (_refreshType != refreshType) {
        _refreshType = refreshType;
        [self prepareRefresh];
    }
}

- (void)prepareRefresh {
    if((_refreshType & HTRefreshTypeTop) == HTRefreshTypeTop){
        [self setRefreshHeaderWithIndicatorClass:[HTRefreshIndicatorView class]];
    }
    if((_refreshType & HTRefreshTypeBottom) == HTRefreshTypeBottom){
        [self setRefreshFooterWithIndicatorClass:[HTRefreshIndicatorView class]];
    }
}

- (void)refreshHeader {
    BOOL refreshRequired = [self refreshHeaderState] != HTRefreshStateRefreshing;
    [super refreshHeader];
    if (refreshRequired) {
        if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(beginRefreshHeader:)]) {
            [self.refreshDelegate beginRefreshHeader:self];
        }
    }
}

- (void)refreshFooter {
    BOOL refreshRequired = [self refreshFooterState] != HTRefreshStateRefreshing;
    [super refreshFooter];
    if (refreshRequired) {
        if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(beginRefreshFooter:)]) {
            [self.refreshDelegate beginRefreshFooter:self];
        }
    }
}

@end
