//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTFileUtilities.h"
#import "HTPathUtilities.h"

@implementation HTFileUtilities

+ (NSString*)getDocumentPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (BOOL) fileExists:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

+ (BOOL) removeFile:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        return [fileManager removeItemAtPath:filePath error:nil];
    }
    return YES;
}

+ (BOOL)moveItemFromOldPath:(NSString *)oldpath toNewPath:(NSString *)newpath{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    if ([fileManager fileExistsAtPath:oldpath]) {
        [fileManager moveItemAtPath:oldpath toPath:newpath error:&error];
    }
    
    if (!error) {
        return YES;
    }else{
        return NO;
    }
}

//+ (NSString *) hostVideoPathWithHouseId:(int)houseId andIndex:(int)index{
//
//    NSString *videoName = [NSString stringWithFormat:@"v%d_%d.mov", index,houseId];
//    if(![HTPathUtilities pathExists:[HTPathUtilities userPath:[LFApplication sharedApplication].userInfo.id]]){
//        [HTPathUtilities createDirectory:[HTPathUtilities userPath:[LFApplication sharedApplication].userInfo.id]];
//    }
//    NSString *videoPath = [[HTPathUtilities userPath:[LFApplication sharedApplication].userInfo.id] stringByAppendingPathComponent:videoName];
//    return videoPath;
//}

@end
