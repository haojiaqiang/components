//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//


#import "HTScrollView.h"

@implementation HTScrollView

- (instancetype) init{
    self = [super init];
    if(self){
        [self loadSubviews];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

- (void) loadSubviews {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

@end
