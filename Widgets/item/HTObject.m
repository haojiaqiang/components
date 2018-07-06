//
//  HTObject.m
//  DemoCompilations
//
//  Created by Hayato on 7/5/18.
//  Copyright © 2018 Hayato. All rights reserved.
//

#import "HTObject.h"

@implementation HTObject

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (!dictionary) {
        return nil;
    }
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    DLog(@"%@ setValue:forUndefinedKey:%@", self, key);
}

@end
