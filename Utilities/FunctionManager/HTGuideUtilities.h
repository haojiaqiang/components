//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTGuideUtilities : NSObject
+ (BOOL) hasGuideSetted:(NSString*) guideName;
+ (void) setGuideForName:(NSString*) guideName;
@end
