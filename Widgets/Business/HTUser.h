//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//
#import "HTJSONModel.h"

@interface HTUser : HTJSONModel

@property (nonatomic, assign) int userId;
@property (nonatomic, strong) NSNumber *nuid;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, assign) int role;
@property (nonatomic, assign) int intergal;
@property (nonatomic, assign) int isBindbankCode;
@property (nonatomic, strong) NSString *bankCode;

@property (nonatomic, retain) NSString *deviceToken;

- (BOOL) hasBadge;

@end
