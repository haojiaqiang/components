//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTPageRequest.h"

@implementation HTPageRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        _limit = 20;
    }
    return self;
}

@end
