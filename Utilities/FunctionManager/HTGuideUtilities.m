//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTGuideUtilities.h"

@implementation HTGuideUtilities

+ (BOOL) hasGuideSetted:(NSString *)guideName{
    return [@"1" isEqualToString: [[NSUserDefaults standardUserDefaults] valueForKey:guideName]];
}

+ (void) setGuideForName:(NSString *)guideName{
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:guideName];
}

@end
