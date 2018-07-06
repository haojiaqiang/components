//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "NSData+Utilities.h"

@implementation NSData (Utilities)

- (NSString*) base64String{
    NSString *s = @"";
    if([self respondsToSelector:@selector(base64EncodedStringWithOptions:)]){
        s = [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    else if([self respondsToSelector:@selector(base64Encoding)]){
        s = [self base64Encoding];
    }
    return s;
}

@end
