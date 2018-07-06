//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImgScrollViewDelegate <NSObject>

- (void) tapImageViewTappedWithObject:(id) sender;

@end

@interface HTImgScrollView : UIScrollView

@property (weak) id<ImgScrollViewDelegate> i_delegate;

- (void) setContentWithFrame:(CGRect) rect;
- (void) setImage:(NSString *) imageUrl defaultName:(NSString *)name;
- (void) setAnimationRect;
- (void) rechangeInitRdct;

@end
