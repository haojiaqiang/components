//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTResponse.h"

@implementation HTResponse

- (BOOL)success {
        return _errorCode.intValue == 0;
}

- (NSString *)errorCode {
    return [NSString stringWithFormat:@"%d", _status];
}

- (NSString *)errorMessage {
    return _message;
}

@end
