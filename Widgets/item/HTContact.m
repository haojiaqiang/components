//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTContact.h"
#import "NSString+Utilities.h"

@implementation HTContact
{
    NSMutableArray *_emails;
    NSMutableArray *_phoneNumbers;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _emails = [NSMutableArray array];
        _phoneNumbers = [NSMutableArray array];
    }
    return self;
}

- (void)addPhoneNumber:(NSString *)phoneNumber {
    if (![self.phoneNumbers containsObject:phoneNumber]) {
        [_phoneNumbers addObject:phoneNumber];
    }
}

- (void)addEmail:(NSString *)email{
    if (![self.emails containsObject:email]) {
        [_emails addObject:email];
    }
}

- (void)setPhoneNumbers:(NSArray *)phoneNumbers {
    [_phoneNumbers removeAllObjects];
    [self addPhoneNumbers:phoneNumbers];
}

- (NSArray *)phoneNumbers {
    return _phoneNumbers;
}

- (void)setEmails:(NSArray *)emails {
    [_emails removeAllObjects];
    [self addEmails:emails];
}

- (NSArray *)emails {
    return _emails;
}

- (void)addPhoneNumbers:(NSArray *)phoneNumbers {
    for (NSString *phoneNumber in phoneNumbers) {
        [self addPhoneNumber:phoneNumber];
    }
}

- (void)addEmails:(NSArray *)emails {
    for (NSString *email in emails) {
        [self addEmail:email];
    }
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[HTContact class]]) {
        return self.recordId == ((HTContact*)object).recordId;
    }
    return NO;
}

- (NSString *)name {
    return [NSString isNullOrEmpty:_fullName]? [NSString stringWithFormat:@"%@%@", _firstName, _lastName] : _fullName;
}

//- (NSString *)description {
//    if(self.phoneNumbers.count + self.emails.count == 1) {
//        if(self.phoneNumbers.count > 0) {
//            return self.phoneNumbers[0];
//        }
//        else {
//            return self.emails[0];
//        }
//    }
//    return [super description];
//}

@end
