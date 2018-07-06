//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTFileManager : NSObject

+ (HTFileManager *)sharedManager;

// Get file manager
- (NSFileManager *)fileManager;

// File related methods
- (BOOL)fileExists:(NSString *)filePath;
- (BOOL)removeFile:(NSString *)filePath;

// Path related methods
- (NSString *)documentPath;
- (BOOL)createDirectory:(NSString *)path;

@end
