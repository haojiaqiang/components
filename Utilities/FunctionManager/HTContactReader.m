//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTContactReader.h"

@implementation HTContactReader
{
    NSArray *_contacts;
}

static HTContactReader *_sharedInstance;

+ (instancetype)allocWithZone:(NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

+ (instancetype)sharedReader {
    return [[self alloc] init];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (void)readContactsOnCompletion:(HTContactRaaderBlock)completion{
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = nil;
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus == kABAuthorizationStatusAuthorized) {
        addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        [self readContacts:addressBook authStatus:authStatus onCompletion:completion];
    }
    else if (authStatus == kABAuthorizationStatusDenied) {
        [self readContacts:addressBook authStatus:authStatus onCompletion:completion];
    }
    else if (authStatus == kABAuthorizationStatusNotDetermined) {
        addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            [self readContacts:addressBook authStatus:granted? kABAuthorizationStatusAuthorized : kABAuthorizationStatusDenied onCompletion:completion];
        });
    }
    else if (authStatus == kABAuthorizationStatusRestricted) {
        [self readContacts:addressBook authStatus:authStatus onCompletion:completion];
    }
}

- (void)readContacts:(ABAddressBookRef) addressBook authStatus:(ABAuthorizationStatus) authStatus onCompletion:(HTContactRaaderBlock) completion {
    if (addressBook){
        if (authStatus == kABAuthorizationStatusAuthorized){
            NSArray *contacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
            if (completion) {
                completion(contacts, authStatus);
            }
        }
        CFRelease(addressBook);
    }
    if (completion) {
        completion(nil, authStatus);
    }
}

@end
