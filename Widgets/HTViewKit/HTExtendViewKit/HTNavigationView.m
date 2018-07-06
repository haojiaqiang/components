//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTNavigationView.h"

@implementation HTNavigationView

- (instancetype) initWithRootView:(UIView *)rootView{
    self = [super init];
    if(self){
        if(rootView){
            [self addSubview:rootView];
        }
    }
    return self;
}

- (void) pushView:(UIView *)view animated:(BOOL)animated{
    
}

- (void) popViewAnimated:(BOOL)animated{
    
}

- (void) popToRootViewAnimated:(BOOL)animated{
    
}

@end
