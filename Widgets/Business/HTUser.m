//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTUser.h"

@implementation HTUser

- (NSNumber*) nuid{
    return [NSNumber numberWithInt:self.userId];
}

- (BOOL) hasBadge {
    return NO;
}

@end
