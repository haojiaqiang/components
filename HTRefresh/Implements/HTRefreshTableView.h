//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+HTRefresh.h"
#import "HTRefreshType.h"

@protocol TWTableViewRefreshingDelegate;

@interface HTRefreshTableView : UITableView

//Refresh Delegate
@property (nonatomic, weak) id<TWTableViewRefreshingDelegate> refreshDelegate;

@property (nonatomic, assign) HTRefreshType refreshType;

// Constructors
- (instancetype)initWithFrame:(CGRect)frame refreshType:(HTRefreshType)refreshTpye;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle) style refreshType:(HTRefreshType)refreshType;

@end

@protocol TWTableViewRefreshingDelegate <NSObject>

@optional
- (void)beginRefreshHeader:(HTRefreshTableView *)tableView;
- (void)beginRefreshFooter:(HTRefreshTableView *)tableView;

@end
