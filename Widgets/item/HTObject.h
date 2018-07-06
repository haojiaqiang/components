//
//  HTObject.h
//  DemoCompilations
//
//  Created by Hayato on 7/5/18.
//  Copyright © 2018 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTObject : NSObject

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
