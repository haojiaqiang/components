//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTJSONModel.h"
#import "NSString+Utilities.h"

@interface HTJSONModel (JSONModel)

- (NSDictionary *)jsonModelDictionary;

- (NSString *)jsonModelJson;

@end

@implementation HTJSONModel

- (instancetype) init {
    self = [super init];
    if (self) {
        _contentSize = CGSizeZero;
    }
    return self;
}

- (CGFloat) contentHeight{
    if(_contentHeight==0){
        [self calculateContentHeight];
    }
    return _contentHeight;
}

- (CGSize) contentSize {
    if (CGSizeEqualToSize(_contentSize, CGSizeZero)) {
        [self calculateContentHeight];
    }
    return _contentSize;
}

- (void) calculateContentHeight{
    
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (!dictionary) {
        return nil;
    }
    NSError *error;
    HTJSONModel *object = [self initWithDictionary:dictionary error:&error];
    if (error) {
        DLog(@"%@", error);
    }
    return object;
}

- (instancetype)initWithJSON:(NSString *)jsonString {
    if ([NSString isNullOrEmpty:jsonString]) {
        return nil;
    }
    NSError *error;
    HTJSONModel *object = [self initWithString:jsonString error:&error];
    if (error) {
        DLog(@"%@", error);
    }
    return object;
}

- (NSDictionary *)dictionary {
    return [self jsonModelDictionary];
}

- (NSString *)json {
    return [self jsonModelJson];
}

+ (Class)classForArray:(NSString *)propertyName {
    return nil;
}

+ (NSArray *)ignoredProperties {
    return nil;
}

+ (instancetype)itemWithDictionary:(NSDictionary <NSString *, id> *)dict {
    HTJSONModel *item = [[self alloc] init];
    [item setValuesForKeysWithDictionary:dict];
    return item;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    DLog(@"%@ serValueForUndefinedKey", self.class);
}

@end

@implementation HTJSONModel (JSONModel)

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    NSArray *ignoredProperties = [self ignoredProperties];
    if (ignoredProperties && [ignoredProperties containsObject:propertyName]) {
        return YES;
    }
    return NO;
}

+ (NSString *)protocolForArrayProperty:(NSString *)propertyName {
    Class clazz = [self classForArray:propertyName];
    if (clazz) {
        return NSStringFromClass([clazz class]);
    }
    return nil;
}

- (NSDictionary *)jsonModelDictionary {
    return [super toDictionary];
}

- (NSString *)jsonModelJson {
    return [super toJSONString];
}

+ (NSDictionary *)convertKeyMapper {
    return nil;
}

+ (JSONKeyMapper *)keyMapper {
    if ([self convertKeyMapper]) {
        return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:[self convertKeyMapper]];
    }
    return nil;
}

@end
