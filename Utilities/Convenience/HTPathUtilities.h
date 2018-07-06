//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTPathUtilities : NSObject
+ (BOOL) pathExists: (NSString*) filePath;
+ (NSString*) userPath:(long long) uid;
+ (NSString*) itemPath:(long long) uid nid:(long long)nid;
+ (NSString*) getDocumentPath;
+ (BOOL) createDirectory:(NSString*) destPath;

@end
