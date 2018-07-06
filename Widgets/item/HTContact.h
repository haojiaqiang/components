//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTContact : NSObject

@property (nonatomic, assign) int recordId;

@property (nonatomic, strong) NSString *firstName;

@property (nonatomic, strong) NSString *lastName;

@property (nonatomic, strong) NSString *fullName;

@property (nonatomic, strong) NSArray *phoneNumbers;

@property (nonatomic, strong) NSArray *emails;

@property (nonatomic, strong, readonly) NSString *name;

- (void)addPhoneNumber:(NSString *)phoneNumber;

- (void)addEmail:(NSString *)email;

- (void)addPhoneNumbers:(NSArray *)phoneNumbers;

- (void)addEmails:(NSArray *)emails;

@end
