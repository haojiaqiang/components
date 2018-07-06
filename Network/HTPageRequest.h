//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTRequest.h"

@interface HTPageRequest : HTRequest

@property (nonatomic, assign) NSInteger offset;

@property (nonatomic, assign) NSInteger limit; // Default 20

@end
