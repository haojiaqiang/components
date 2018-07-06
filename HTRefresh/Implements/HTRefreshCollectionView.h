//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+HTRefresh.h"
#import "HTRefreshType.h"

@protocol HTCollectionViewRefreshingDelegate;

@interface HTRefreshCollectionView : UICollectionView

//Refresh Delegate
@property (nonatomic, weak) id<HTCollectionViewRefreshingDelegate> refreshDelegate;

@property (nonatomic, assign) HTRefreshType refreshType;

// Constructors
- (instancetype)initWithFrame:(CGRect)frame refreshType:(HTRefreshType)refreshType;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout refreshType:(HTRefreshType)refreshType;

@end

@protocol HTCollectionViewRefreshingDelegate <NSObject>

@optional
- (void)beginRefreshHeader:(HTRefreshCollectionView *)collectionView;
- (void)beginRefreshFooter:(HTRefreshCollectionView *)collectionView;

@end
