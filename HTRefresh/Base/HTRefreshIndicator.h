//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTRefreshIndicator <NSObject>

@optional
- (CGFloat)indicatorHeight;
- (void)start;
- (void)stop;
- (void)reset;
- (void)pullingWithRatio:(CGFloat)ratio;

@end
