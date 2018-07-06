//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTFileUtilities : NSObject

+ (NSString*) getDocumentPath;
+ (BOOL) fileExists: (NSString*) filePath;
+ (BOOL) removeFile:(NSString*) filePath;
+ (BOOL) moveItemFromOldPath:(NSString *)oldpath toNewPath:(NSString *)newpath;

@end
