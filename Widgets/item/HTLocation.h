//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTLocation : NSObject

@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@end
