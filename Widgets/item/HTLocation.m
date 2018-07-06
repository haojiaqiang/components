//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTLocation.h"
#import "NSString+Utilities.h"

@implementation HTLocation

- (NSString*) country {
    return [NSString safeString:_country];
}

- (NSString*) state {
    return [NSString safeString:_state];
}

- (NSString*) city {
    return [NSString safeString:_city];
}

- (NSString*) area {
    return [NSString safeString:_area];
}

- (NSString*) address {
    return [NSString safeString:_address];
}

@end
