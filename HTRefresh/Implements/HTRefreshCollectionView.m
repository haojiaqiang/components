//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTRefreshCollectionView.h"
#import "HTRefreshIndicatorView.h"
#import "HTRefreshIndicatorViewGodenCudgel.h"

@implementation HTRefreshCollectionView
{
    HTRefreshType _refreshType;
}

- (id)initWithFrame:(CGRect)frame refreshType:(HTRefreshType)refreshType {
    self = [super initWithFrame:frame];
    if (self) {
        _refreshType = refreshType;
        [self prepareRefresh];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout refreshType:(HTRefreshType)refreshType {
    self = [super initWithFrame:frame collectionViewLayout:layout];
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
        [self setRefreshHeaderWithIndicatorClass:[HTRefreshIndicatorViewGodenCudgel class]];
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
    BOOL refreshRequired = [self refreshHeaderState] != HTRefreshStateRefreshing;
    [super refreshFooter];
    if (refreshRequired) {
        if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(beginRefreshFooter:)]) {
            [self.refreshDelegate beginRefreshFooter:self];
        }
    }
}

@end
