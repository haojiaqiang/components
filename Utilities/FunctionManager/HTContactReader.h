//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

typedef void (^HTContactRaaderBlock)(NSArray *contacts, ABAuthorizationStatus status);

@interface HTContactReader : NSObject

+ (HTContactReader*)sharedReader;

- (void) readContactsOnCompletion:(HTContactRaaderBlock)completion;

@end
