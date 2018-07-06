//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTJSONModel.h"

@interface HTResponse : HTJSONModel

@property (nonatomic, strong) NSString *errorCode;

@property (nonatomic, strong) NSString *errorMessage;

@property (nonatomic, assign, readonly) BOOL success;

@property (nonatomic, strong, readonly) id responseObject;

#pragma mark - 添加
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *message;

@end
