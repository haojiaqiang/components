//
//  Created by Hayato on 2016/3/23.
//  Copyright © 2016年 Hayato. All rights reserved.
//

#import "HTDBUtilities.h"
#import "HTFileUtilities.h"
#import <sqlite3.h>

#define dbName @"Mars.sqlite"

@implementation HTDBUtilities
{
    sqlite3 *database;
}

static HTDBUtilities* _sharedInstance = nil;

+ (HTDBUtilities*) sharedInstance
{
    @synchronized([HTDBUtilities class])
	{
        if(!_sharedInstance)
            _sharedInstance = [[self alloc]init];
        return _sharedInstance;
    }
    return nil;
}

+ (id)alloc
{
    @synchronized([HTDBUtilities class])
	{
		NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedInstance = [super alloc];
		return _sharedInstance;
	}
	return nil;
}

- (NSString*) getDbFile{
    NSString *documentPath = [HTFileUtilities getDocumentPath];
    return [documentPath stringByAppendingPathComponent:dbName];
}

- (BOOL) createTablesIfNotExists{
    char *err;
    NSString* sql = [[NSBundle mainBundle] pathForResource:@"db"
                                                    ofType:@"sql"];
    NSString *query = [NSString stringWithContentsOfFile:sql encoding:NSUTF8StringEncoding error:NULL];
    if(sqlite3_exec(database, [query UTF8String], nil, nil, &err)!=SQLITE_OK){
        DLog(@"Failed to create table. with error: %s", err);
        return NO;
    }
    return YES;
}

- (BOOL) openDatabase{
    if(![HTFileUtilities fileExists:[self getDbFile]]){
        if(sqlite3_open([[self getDbFile] UTF8String], &database)==SQLITE_OK){
            if([self createTablesIfNotExists]){
                return YES;
            }
        }
    }else{
        if(sqlite3_open([[self getDbFile] UTF8String], &database)==SQLITE_OK){
            return YES;
        }
    }
    return NO;
}

- (void) dealloc
{
    database = nil;
#if __has_feature(objc_arc)
#else
    [super dealloc];
#endif
}

@end
