//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "UITableViewCell+Nib.h"

@implementation UITableViewCell (Nib)

#pragma mark - Class

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

+ (UINib *)nib {
    return [UINib nibWithNibName:[self identifier] bundle:nil];
}

@end
