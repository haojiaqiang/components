//
//  UITableView+IndexTip.m
//  LiFang
//
//  Created by Hayato on 2018/8/2.
//  Copyright © 2017年 Lifang. All rights reserved.
//

#import "UITableView+IndexTip.h"
#import "Aspects.h"
#import <objc/runtime.h>

#pragma mark - 需要添加Aspects
@interface HTIndexTipManager : NSObject

@property (strong,nonatomic) UILabel * indexTipLabel;

@end

@implementation HTIndexTipManager

-(UILabel *)indexTipLabel {
    if(!_indexTipLabel){
        _indexTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _indexTipLabel.textAlignment = NSTextAlignmentCenter;
        _indexTipLabel.textColor = [UIColor blackColor];
        _indexTipLabel.font = [UIFont systemFontOfSize:28];
    }
    return _indexTipLabel;
}

@end

@interface UITableView ()

@property(strong,nonatomic) HTIndexTipManager * manager;

@end

@implementation UITableView (IndexTip)

static char HTIndexTipManagerKey;

-(void)setManager:(HTIndexTipManager *)manager {
    [self willChangeValueForKey:@"HTIndexTipManagerKey"];
    objc_setAssociatedObject(self, &HTIndexTipManagerKey,
                             manager,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"HTIndexTipManagerKey"];
}

-(HTIndexTipManager *)manager {
    return objc_getAssociatedObject(self, &HTIndexTipManagerKey);
}

-(void)addIndexTip {
    if(!self.manager){
        self.manager = [[HTIndexTipManager alloc] init];
    }
    
    NSObject * delegate = self.delegate;
    
    if(!delegate) {
        NSException *excp = [NSException exceptionWithName:@"设置TableView代理delegate" reason:@"IndexTip >> 调用addIndexTip方法之前，UITableView 需要设置delegate" userInfo:nil];
        [excp raise]; // 抛出异常,提示错误
        return;
    }
    if(![delegate respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
        NSException *excp = [NSException exceptionWithName:@"实现TableView代理方法" reason:@"IndexTip >> UITableView delegate 需要实现方法sectionIndexTitlesForTableView:" userInfo:nil];
        [excp raise]; // 抛出异常,提示错误
        return;
    }
    if(![delegate respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
        NSException *excp = [NSException exceptionWithName:@"实现TableView代理方法" reason:@"IndexTip >> UITableView delegate 需要实现方法tableView:sectionForSectionIndexTitle:atIndex:" userInfo:nil];
        [excp raise]; // 抛出异常,提示错误
        return;
    }
    // hack
    [delegate aspect_hookSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, UITableView *tableView,NSString *title,NSInteger index) {
        [self handleWithIndexTitle:title atIndex:index];
        return index;
    } error:NULL];
}

-(void)handleWithIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    // 找出TableView的索引视图UITableViewIndex
    UIView * view = (UIView*)self.subviews.lastObject;
    if(![NSStringFromClass([view class]) isEqualToString:@"UITableViewIndex"]){
        for(UIView * subView in self.subviews){
            if([NSStringFromClass([subView class]) isEqualToString:@"UITableViewIndex"]){
                view = subView;
                break;
            }
        }
    }
    
    CGPoint center = CGPointMake(-0.5 * view.frame.origin.x, 0.5 * view.frame.size.height);
    //添加索引提示视图到UITableViewIndex上
    self.manager.indexTipLabel.center = center;
    if(self.manager.indexTipLabel.superview != view) {
        [view addSubview:self.manager.indexTipLabel];
    }
    //拦截TableView的索引视图UITableViewIndex的touches事件
    __weak typeof(self) weakSelf = self;
    [view aspect_hookSelector:@selector(touchesBegan:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, NSSet *touches,UIEvent *event) {
        weakSelf.manager.indexTipLabel.hidden = NO;
    } error:NULL];
    [view aspect_hookSelector:@selector(touchesMoved:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, NSSet *touches,UIEvent *event) {
         weakSelf.manager.indexTipLabel.hidden = NO;
    } error:NULL];
    [view aspect_hookSelector:@selector(touchesEnded:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, NSSet *touches,UIEvent *event) {
         weakSelf.manager.indexTipLabel.hidden = YES;
    } error:NULL];
    [view aspect_hookSelector:@selector(touchesCancelled:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, NSSet *touches,UIEvent *event) {
         weakSelf.manager.indexTipLabel.hidden = YES;
    } error:NULL];
    
    self.manager.indexTipLabel.text = title;
}

@end




