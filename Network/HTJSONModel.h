//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "JSONModelLib.h"

@interface HTJSONModel : JSONModel
{
    CGFloat _contentHeight;
    CGSize _contentSize;
}

- (CGFloat)contentHeight;

- (CGSize)contentSize;

- (void)calculateContentHeight;

- (NSString *)json;

- (NSDictionary *)dictionary;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithJSON:(NSString *)jsonString;

+ (NSArray *)ignoredProperties;

+ (Class)classForArray:(NSString *)propertyName;

+ (instancetype)itemWithDictionary:(NSDictionary <NSString *, id> *)dict;

@end
