//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTFileManager.h"

@implementation HTFileManager

static HTFileManager *_sharedInstance = nil;

+ (HTFileManager *)sharedManager {
    @synchronized([HTFileManager class]) {
        if(!_sharedInstance)
            _sharedInstance = [[self alloc] init];
        return _sharedInstance;
    }
    return nil;
}

+ (instancetype)alloc {
    @synchronized([HTFileManager class]) {
        NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedInstance = [super alloc];
        return _sharedInstance;
    }
    return nil;
}

- (NSFileManager *)fileManager {
    return [NSFileManager defaultManager];
}

- (BOOL)fileExists:(NSString *)filePath{
    return [self.fileManager fileExistsAtPath:filePath];
}

- (BOOL)removeFile:(NSString *)filePath {
    if ([self.fileManager fileExistsAtPath:filePath]) {
        return [self.fileManager removeItemAtPath:filePath error:nil];
    }
    return YES;
}

- (NSString *)documentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (BOOL)createDirectory:(NSString *)path {
    if (![self fileExists:path]) {
        NSURL* url = [NSURL fileURLWithPath:path];
        NSError *error;
        return [self.fileManager createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&error];
    }
    return YES;
}

@end
