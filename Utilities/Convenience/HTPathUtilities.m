//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTPathUtilities.h"

@implementation HTPathUtilities

+ (BOOL) pathExists: (NSString*) path{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

+(NSString*)userPath:(long long)uid{
    NSString *documentPath = [self getDocumentPath];
    return [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld",uid]];
}

+(NSString*)itemPath:(long long) uid nid:(long long)nid{
    NSString *documentPath = [self getDocumentPath];
    NSString *userPath = [self userPath:uid];
    if(![self pathExists:userPath]){
        [self createDirectory:userPath];
    }
    return [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld/%lld",uid, nid]];
}

+(NSString*)getDocumentPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+(BOOL) createDirectory:(NSString *)destPath{
    NSURL* url = [NSURL fileURLWithPath:destPath];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError *error;
    return [fileManager createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&error];
}

@end
