//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "HTContact.h"

typedef void (^HTAddressBookReaderBlock)(NSArray *contacts, ABAuthorizationStatus authorizationStatus);

@interface HTAddressBookReader : NSObject

+ (HTAddressBookReader *)sharedReader;

- (void)readAddressBookOnCompletion:(HTAddressBookReaderBlock)completion;

- (void)readAddressBookAsynchronouslyOnCompletion:(HTAddressBookReaderBlock)completion;

@end
