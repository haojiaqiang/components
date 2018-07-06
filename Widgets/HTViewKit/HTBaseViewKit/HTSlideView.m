//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTSlideView.h"
#import "HTCollectionView.h"
#import "HTLabel.h"
#import "HTPageControl.h"
#import "Constants.h"
#import "HTImageView.h"

@implementation HTSlideViewCellView

- (void)showWithItemData:(id)data {
    
}

@end

@implementation HTSlideViewCell
{
    HTSlideViewCellView *_itemView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.contentView.autoresizingMask = self.autoresizingMask;
    }
    return self;
}

- (void)setItemClass:(Class)clazz {
    if (!_itemView || ![_itemView isKindOfClass:clazz]) {
        if (_itemView) {
            [_itemView removeFromSuperview];
            _itemView = nil;
        }
        if (clazz && [clazz isSubclassOfClass:[HTSlideViewCellView class]]) {
            _itemView = [[clazz alloc] initWithFrame:self.contentView.bounds];
            [self.contentView addSubview:_itemView];
        }
    }
}

- (void)showWithItemData:(id)data {
    if (_itemView) {
        _itemView.frame = self.contentView.bounds;
        [_itemView showWithItemData:data];
    }
}

- (HTSlideViewCellView *)itemView {
    return _itemView;
}

@end

static NSString *HTSlideViewCellIdentifier = @"HTSlideViewCellIdentifier";

@interface HTSlideView (CollectionViewDelegate)  <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation HTSlideView
{
    NSTimer *_timer;
    HTView *_indexView;
    HTLabel *_indexLabel;
    UIPageControl *_pageControl;
}

- (instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)dataArray {
    self = [self initWithFrame:frame];
    if (self) {
        _dataArray = dataArray;

        if (_collectionView) {
            [_collectionView reloadData];
        }
    }
    return self;
}

- (void)dealloc {
    self.selectItemAtIndexPathWithData = nil;
    self.placeholderView = nil;
    self.didPrepareItemAtIndexPathWithData = nil;
    self.didScrollToIndex = nil;
    if (_timer) {
        [_timer invalidate];
    }
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


- (void)loadSubviews {
    [super loadSubviews];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumLineSpacing:0];

    _collectionView = [[HTCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.collectionView.pagingEnabled =YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.bounces = NO;
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self setItemCellClass:[HTSlideViewCell class]];
    
    [self addSubview:self.collectionView];
    self.collectionView.scrollsToTop = NO;
    
    self.collectionView.backgroundColor = kRGB(51, 51, 51);
    _cyclable = NO;
}

- (void)setItemCellClass:(Class)itemCellClass {
    if ([itemCellClass isSubclassOfClass:[HTSlideViewCell class]]) {
        [self.collectionView registerClass:itemCellClass forCellWithReuseIdentifier:HTSlideViewCellIdentifier];
        [self.collectionView reloadData];
    }
}

- (void)setShowsIndex:(BOOL)showsIndex {
    _showsIndex = showsIndex;
    if (_showsIndex) {
        if (!_indexView) {
            _indexView = [[HTView alloc] initWithFrame:CGRectMake(self.frame.size.width - 62, 10, 47, 24) andRadius:12];
            _indexView.backgroundColor = kRGBA(0, 0, 0, 0.5);
            [self addSubview:_indexView];
            
            _indexLabel = [[HTLabel alloc] initWithFrame:_indexView.bounds];
            _indexLabel.textAlignment = NSTextAlignmentCenter;
            _indexLabel.font = kAppFont(12);
            _indexLabel.textColor = kWhiteColor;
            [_indexView addSubview:_indexLabel];
            
            [self refreshIndex];
        }
    }
    else if (_indexView) {
        [_indexView removeFromSuperview];
        _indexView = nil;
    }
}

- (void)setShowsPageControl:(BOOL)showsPageControl {
    _showsPageControl = showsPageControl;
    if (_showsPageControl) {
        if (!_pageControl) {
            Class clazz = [self pageControlClass];
            if (clazz && [clazz isSubclassOfClass:[UIPageControl class]]) {
                _pageControl = [[clazz alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 14)];
                [self addSubview:_pageControl];
            }
            [self refreshIndex];
        }
    }
    else if (_pageControl) {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }
}

- (Class)pageControlClass {
    return [HTPageControl class];
}

- (void)setRepeatTime:(NSTimeInterval)repeatTime {
    if (_repeatTime == repeatTime) {
        return;
    }
    if (_timer) {
        [_timer invalidate];
    }
    _repeatTime = repeatTime;
    if (repeatTime > 0) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:repeatTime target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
        _status = HTSlideScrollStatusActive;
    }
}

- (void)handleTimer:(NSTimer *)timer {
    if (self.dataArray.count == 0) {
        if (_timer) {
            [_timer invalidate];
        }
        return;
    }
    if (_status == HTSlideScrollStatusActive) {
        NSInteger toIndex = self.collectionView.contentOffset.x / self.collectionView.frame.size.width + 1;
        if (_cyclable) {
            if (toIndex > self.dataArray.count) {
                toIndex = 1;
                [self.collectionView setContentOffset:CGPointMake(0, 0)];//let last item to first smoothly
            }
        }
        else if (toIndex >= self.dataArray.count) {
            if (_timer) {
                [_timer invalidate];
            }
            return;
        }
        CGRect rect = self.collectionView.bounds;
        rect.origin.x = toIndex * rect.size.width;
        [self.collectionView scrollRectToVisible:rect animated:YES];
        
        if (self.didScrollToIndex) {
            if (_cyclable) {
                toIndex = (toIndex + self.dataArray.count - 1) % self.dataArray.count;
            }
            self.didScrollToIndex(self, toIndex);
        }
    }
}

- (void)setCyclable:(BOOL)cyclable {
    _cyclable = cyclable;
    [_collectionView reloadData];
}

- (void)refreshWithData:(NSArray *)dataArray {
    if (!dataArray || dataArray.count == 0) {
        if (!self.placeholderView) {
            self.placeholderView = [[HTImageView alloc] initWithFrame:self.bounds];
            self.placeholderView.image = [UIImage imageNamed:@"house-detail-default"];
            self.placeholderView.contentMode = UIViewContentModeScaleAspectFill;
        }
        [self.collectionView insertSubview:self.placeholderView atIndex:0];
    } else {
        [self.placeholderView removeFromSuperview];
    }
    [self refreshWithData:dataArray scrollToIndex:0];
}

- (void)refreshWithData:(NSArray *)dataArray scrollToIndex:(int)index {
    _dataArray = dataArray;
    [self.collectionView reloadData];
    
    [self performSelector:@selector(refreshIndex) withObject:nil afterDelay:0.25];
    
    if (self.dataArray.count > 0) {
        if (_cyclable) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index + 1 inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath
                                        atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            if (self.didScrollToIndex) {
                self.didScrollToIndex(self, index);
            }
        }
        else {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }
    [self refreshIndex];
}

- (void)scrollToIndex:(NSInteger)index withAnimation:(BOOL)animated {
    if (index < 0 || !self.dataArray || index > self.dataArray.count + (_cyclable? 1 : -1) )
        return;
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    [self adjustCycleCell:self.collectionView];
    if (self.didScrollToIndex) {
        self.didScrollToIndex(self, index);
    }
}

- (void)adjustCycleCell:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    NSInteger currentIndex = offset.x / bounds.size.width;
    
    if (_cyclable) {
        if (currentIndex == 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.dataArray.count inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
        else if (currentIndex == self.dataArray.count + 1) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }
    [self performSelector:@selector(checkScrollStatus) withObject:nil afterDelay:_repeatTime];
}

- (void)checkScrollStatus {
    if (_status == HTSlideScrollStatusPaused) {
        _status = HTSlideScrollStatusActive;
    }
}

- (void)didEndDisplayingCell:(UICollectionViewCell *)cell collectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
}

- (void)refreshIndex {
    if (_showsIndex || _showsPageControl) {
        NSInteger currentIndex = _collectionView.contentOffset.x / _collectionView.frame.size.width;
        if (_cyclable) {
            currentIndex = (currentIndex + self.dataArray.count - 1) % self.dataArray.count;
        }
        if (_showsIndex) {
            _indexLabel.text = [NSString stringWithFormat:@"%d / %d", (int)currentIndex + 1, (int)self.dataArray.count];
        }
        if (_showsPageControl) {
            _pageControl.numberOfPages = self.dataArray.count;
            _pageControl.currentPage = currentIndex;
        }
    }
}

- (void)selectItemAtCurrentIndexPath {
    NSInteger currentIndex = _collectionView.contentOffset.x / _collectionView.frame.size.width;
    [self collectionView:_collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
}

@end

@implementation HTSlideView (CollectionViewDelegate)

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (self.dataArray != nil && self.dataArray.count > 0){
        if (_cyclable) {
            count = self.dataArray.count + 2;
        }
        else {
            count = self.dataArray.count;
        }
    }
    return count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTSlideViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:HTSlideViewCellIdentifier forIndexPath:indexPath];
    
    //if ([cell isMemberOfClass:[HTSlideViewCell class]]) {
    if ([cell isKindOfClass:[HTSlideViewCell class]]) {
        [cell setItemClass:_itemViewClass];
    }
    
    if (_cyclable) {
        NSInteger row = (indexPath.row + self.dataArray.count - 1) % self.dataArray.count;
        indexPath = [NSIndexPath indexPathForItem:row inSection:indexPath.section];
    }
    
    //datesource 更好一点
    if (self.didPrepareItemAtIndexPathWithData != nil) {
        self.didPrepareItemAtIndexPathWithData(self, cell, indexPath, [self.dataArray objectAtIndex:indexPath.row]);
    }
    
    [cell showWithItemData:[self.dataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkScrollStatus) object:nil];
    if (_status == HTSlideScrollStatusActive) {
        _status = HTSlideScrollStatusPaused;
    }
}

- (void)scrollViewDidEndDecelerating:(UICollectionView *)scrollView {
    if (self.didScrollToIndex) {
        NSInteger currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        if (_cyclable) {
            currentIndex = (currentIndex + self.dataArray.count - 1) % self.dataArray.count;
        }
        self.didScrollToIndex(self, currentIndex);
    }
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        [self adjustCycleCell:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UICollectionView *)scrollView {
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        [self adjustCycleCell:scrollView];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self refreshIndex];
    [self didEndDisplayingCell:cell collectionView:collectionView atIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (_cyclable) {
        NSInteger row = (indexPath.row + self.dataArray.count - 1) % self.dataArray.count;
        indexPath = [NSIndexPath indexPathForItem:row inSection:indexPath.section];
    }
    
    if (self.selectItemAtIndexPathWithData != nil) {
        self.selectItemAtIndexPathWithData(self, cell, indexPath, [self.dataArray objectAtIndex:indexPath.row]);
    }
}

@end
