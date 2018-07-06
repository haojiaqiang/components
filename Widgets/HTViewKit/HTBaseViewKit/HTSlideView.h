//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTView.h"
#import "HTCollectionViewCell.h"

typedef NS_ENUM(NSInteger, HTSlideScrollStatus) {
    HTSlideScrollStatusNone = 0,
    HTSlideScrollStatusPaused = 1,
    HTSlideScrollStatusActive = 2
};

@class HTCollectionView, HTSlideViewCellView;

@interface HTSlideViewCell : HTCollectionViewCell

/// Return HTSlideItemView If itemViewClass of slideView is setted
@property (nonatomic, strong, readonly) HTSlideViewCellView *itemView;

- (void)showWithItemData:(id)data;

@end

@interface HTSlideViewCellView : HTView

- (void)showWithItemData:(id)data;

@end

@interface HTSlideView : HTView

@property (nonatomic, strong, readonly) HTCollectionView *collectionView;

/// Item view class, It must be inherit from HTSlideViewCellView, and implement the method showWithItemData:
@property (nonatomic, strong) Class itemViewClass;

/// Item cell class, It must be inherit from HTSlideViewCell, and implement the method showWithItemData:
@property (nonatomic, strong) Class itemCellClass;

@property (nonatomic, strong) NSArray *dataArray;

/**
 cell样式自定义，有3种解决方案，目前采用block
 1 block回调，让使用HTSlideView的地方，在block中定义Cell样式
 2 Datesource，类似于UITabelView,使用HTSlideView的地方实现协议方法，让self.datesource提供cell样式
 3 模板方法模式，针对接口编程，子类重写自定义cell方法，子类提供cell样式
 */
@property (nonatomic, copy) void(^didPrepareItemAtIndexPathWithData)(HTSlideView *slideView, HTSlideViewCell *cell, NSIndexPath *indexPath, id data);

// item的点击回调
@property (nonatomic, copy) void(^selectItemAtIndexPathWithData)(HTSlideView *slideView, HTSlideViewCell *cell, NSIndexPath *indexPath, id data);

// 滑动事件回调
@property (nonatomic, copy) void(^didScrollToIndex)(HTSlideView *slideView, NSInteger index);

@property (nonatomic, assign) NSTimeInterval repeatTime;

@property (nonatomic, assign) HTSlideScrollStatus status;

@property (nonatomic, assign) BOOL cyclable;

@property (nonatomic, assign) BOOL showsIndex;

/// Return index view when showsIndex enabled
@property (nonatomic, strong, readonly) HTView *indexView;

@property (nonatomic, assign) BOOL showsPageControl;

/// Return page control when showsPageControl enabled
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

@property (nonatomic, strong) UIImageView *placeholderView;

- (Class)pageControlClass;

- (instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)dataArray;

- (void)refreshWithData:(NSArray *)dataArray;

- (void)refreshWithData:(NSArray *)dataArray scrollToIndex:(int)index;

- (void)scrollToIndex:(NSInteger)index withAnimation:(BOOL)animated;

- (void)selectItemAtCurrentIndexPath;

@end
