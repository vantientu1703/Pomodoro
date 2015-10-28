//
//  MoneyDBController.m
//  Money Lover
//
//  Created by Pham Quang Thang on 11/23/12.
//  Copyright (c) 2012 ZooStudio. All rights reserved.
//

#import "MoneyDBController.h"

static MoneyDBController *instance = nil;
static NSString *documentDir = nil;

static NSString *TABLE_CREATE_TASKS = @"CREATE TABLE IF NOT EXISTS \"todos\" \
                                        (\"id\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,\
                                         \"content\" text, status INTEGER DEFAULT 0)";

NSString *TABLE_CREATE_COUNT = @"CREATE TABLE IF NOT EXISTS \"counts\" \
                                (\"id\" INTEGER PRIMARY KEY NOT NULL, \
                                \"cat_id\" INTEGER NOT NULL , \
                                \"number\" INTEGER NOT NULL , \
                                \"created_date\" DATETIME NOT NULL DEFAULT (CURRENT_DATE) ,\
                                \"note\" VARCHAR(140))";

@implementation MoneyDBController
@synthesize sqlite,onCompletion,onFailure;

#define kDOCSFOLDER                                 [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

+ (MoneyDBController *)getInstance {
    @synchronized(self){
        if (instance == nil) {
            instance = [[MoneyDBController alloc] init];
        }
    }
    return instance;
}

- (sqlite3*)openDB:(NSString*)fileName {
    @try {
        // Database path
        if (documentDir != nil) {
            documentDir = nil;
        }
        NSString *sqlPath = [MoneyDBController dbPath:fileName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL isExitst = NO;
        if ([fileManager fileExistsAtPath:sqlPath]) {
            isExitst = YES;
        }
        if (sqlite3_open_v2([sqlPath UTF8String], &sqlite, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK) {
            if (!isExitst) {
                [self createTable];
            }
            
            sqlite3_exec(sqlite, [@"PRAGMA auto_vacuum = FULL" UTF8String], nil, nil, nil);
        } else {
            NSLog(@"Open Error: %@", [NSString stringWithUTF8String:sqlite3_errmsg(sqlite)]);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Cannot OPEN DB %@",exception);
    }
    @finally {
        
    }
    return sqlite;
}

#pragma mark - Create table
- (void)createTable {

    
    [self executeQuery:TABLE_CREATE_TASKS];
    

    //[self executeQuery:TABLE_CREATE_COUNT];
}


- (NSInteger)executeQuery:(NSString *)query {
    if (sqlite == nil) {
        return -1;
    }
    
    sqlite3_stmt *statement;
    @try {
        if(sqlite3_prepare_v2(sqlite, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                return 1;
            } else {
                NSLog(@"sqlite3_step Error: %@", [NSString stringWithUTF8String:sqlite3_errmsg(sqlite)]);
            }
        } else {
            NSLog(@"sqlite3_prepare_v2 Error: %@", [NSString stringWithUTF8String:sqlite3_errmsg(sqlite)]);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: Cannot create table %@",exception);
    }
    @finally {
        if (statement != nil) {
            sqlite3_finalize(statement);
        }
    }
    
    return -1;
}

#pragma mark - Support select, insert, delete, update
- (long)insert:(NSString*)table_name data:(NSDictionary *)data {
    
    long reval = -1;
    if (!self.sqlite) {
        return reval;
    }
    
    NSArray *arKeys = [data allKeys];
    
    NSMutableString *sqlCommand = [[NSMutableString alloc]init];
    NSMutableString *strField = [[NSMutableString alloc]init];
    NSMutableString *strValue = [[NSMutableString alloc]init];

    for (NSString *field_name in arKeys) {
        if ([strField length]>0 && [strValue length]>0) {
            [strField appendFormat:@","];
            [strValue appendFormat:@","];
        }
        [strField appendFormat:@"%@",field_name];
        [strValue appendFormat:@"?"];
    }
    [sqlCommand appendFormat:@"INSERT INTO %@(%@) VALUES(%@)",table_name,strField,strValue];
    NSLog(@"%@",sqlCommand);
    
    sqlite3_stmt *statement = nil;
    
    @try {
        if (sqlite3_prepare_v2(self.sqlite, [sqlCommand UTF8String], -1, &statement, nil) == SQLITE_OK) {
            NSInteger index = 1;
            for (NSString *field_name in arKeys) {
                NSString* value = [data valueForKey:field_name];
                sqlite3_bind_text(statement, index++, [value UTF8String], -1, nil);
            }
        }
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            reval = sqlite3_last_insert_rowid(sqlite);
        } else {
            NSLog(@"insert db ERROR! %s", sqlite3_errmsg(sqlite));
        }
        
//        onCompletion(reval);
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: Cannot insert data to DB!");
//        onFailure();
    }
    @finally {
        if (statement != nil) {
            sqlite3_finalize(statement);
        }
    }
    
    return reval;
}

- (NSInteger)update:(NSString*)table_name data:(NSDictionary*)data whereClause:(NSString*)clause whereArgs:(NSArray*)args {
    NSInteger reval = -1;
    if (!self.sqlite) {
        return reval;
    }
    
    NSArray *arKeys = [data allKeys];
    
    NSMutableString *sqlCommand = [[NSMutableString alloc]init];
    NSMutableString *strField = [[NSMutableString alloc]init];
    
    [sqlCommand appendFormat:@"UPDATE %@ SET ",table_name];
    
    for (NSString *key in arKeys) {
        if (strField.length > 0) {
            [strField appendFormat:@", "];
        }
        [strField appendFormat:@"%@ = ? ",key];
    }
    [sqlCommand appendFormat:@"%@ where %@",strField,clause];
    NSLog(@"%@",sqlCommand);
    
    sqlite3_stmt *statement = nil;
    @try {
        if (sqlite3_prepare_v2(sqlite, [sqlCommand UTF8String], -1, &statement, nil) == SQLITE_OK) {
            NSInteger index=1;
            NSString *sValue = nil;
            
            for (NSString *key in arKeys) {
                sValue = [data valueForKey:key];
                sqlite3_bind_text(statement, index++, [sValue UTF8String], -1, nil);
                sValue = nil;
            }
            
            for (sValue in args) {
                sqlite3_bind_text(statement, index++, [sValue UTF8String], -1, nil);
                sValue = nil;
            }
            
            if (sqlite3_step(statement) == SQLITE_DONE) {
                reval = sqlite3_total_changes(sqlite);
//                onCompletion();
            } else {
                NSLog(@"Update error: %s",sqlite3_errmsg(sqlite));
            }
        } else {
            NSLog(@"Update error: %s",sqlite3_errmsg(sqlite));            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Update exception: %@",exception);
        onFailure();
    }
    @finally {
        if (statement != nil) {
            sqlite3_finalize(statement);
        }
    }
    return reval;
}

- (NSInteger)delete:(NSString*)table_name conditionString:(NSString*)conditionString conditionValue:(NSArray*)conditionValue {
    NSInteger reval = 0;
    NSMutableString *sqlCommand = [NSMutableString stringWithFormat:@"DELETE FROM %@ ", table_name];
    NSMutableString *tempColumn = [NSMutableString stringWithString:@""];
    NSMutableString *tempvalue = [NSMutableString stringWithFormat:@" WHERE %@", conditionString];
    [sqlCommand appendString:tempColumn];
    [sqlCommand appendString:tempvalue];

    sqlite3_stmt *statement = nil;
    
    @try {
        if (sqlite3_prepare_v2(self.sqlite, [sqlCommand UTF8String], -1, &statement, nil) == SQLITE_OK) {
            
            NSInteger index = 1;
            NSString *value = nil;
            
            for (value in conditionValue) {
                sqlite3_bind_text(statement, index++, [value UTF8String], -1, nil);
                value = nil;
            }
            
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                reval = sqlite3_total_changes(self.sqlite);
                
            } else {
                NSLog(@"error insert with table and parameter: %@", sqlite3_errmsg16(sqlite));
            }
            
            
        } else {
            NSLog(@"error insert with table and parameter: %@", sqlite3_errmsg16(sqlite));
        }
//        onCompletion();
    }
    @catch (NSException *exception) {
        NSLog(@"Delete exception: %@",exception);
        onFailure();
    }
    @finally {
        if (statement != nil) {
            sqlite3_finalize(statement);
        }
    }
    return reval;
}

- (NSArray*)rawQuery:(NSString*)sqlCommand args:(NSArray*)selectionArgs {
    
    NSMutableArray *reval;
    
    sqlite3_stmt *statement;
    NSLog(@"%@",sqlCommand);
    @try {
        if (sqlite3_prepare_v2(sqlite, [sqlCommand UTF8String], -1, &statement, nil) ==SQLITE_OK)
        {
            NSInteger index=1;
            NSString *sValue;
            
            for (sValue in selectionArgs) {
                sqlite3_bind_text(statement, index++, [sValue UTF8String], -1, nil);
                sValue = nil;
            }
            
            reval = [[NSMutableArray alloc]init];
            NSMutableDictionary *keyValue = nil;
            NSInteger count = 0;
            NSString *column = nil;
            NSString *cValue = nil;
            
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                @try {
                    keyValue = [[NSMutableDictionary alloc] init];
                    
                    count = sqlite3_column_count(statement);
                    for (int i = 0; i < count; i++) {
                        column = [ZooDBUtil stringFromUTF8:(const char *)sqlite3_column_name(statement, i)];
                        cValue = [ZooDBUtil stringFromUTF8:(const char*)sqlite3_column_text(statement, i)];
                        
                        [keyValue setValue:cValue forKey:column];
                        
                        column = nil;
                        cValue = nil;
                    }
                    [reval addObject:keyValue];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    if (keyValue != nil) {
                        keyValue = nil;
                    }
                    count = 0;
                }
            }
        }
//        onCompletion();
    }
    @catch (NSException *exception) {
        NSLog(@"Raw error: %@",exception);
        onFailure();
    }
    @finally {
        if (statement != nil) {
            sqlite3_finalize(statement);
        }
    }
    
    return reval;
}

/**
 Raw query
*/
- (NSArray*)rawQueryWithCommand:(NSString*)sqlCommand args:(NSArray*)selectionArgs {
    
    NSMutableArray *reval;
    
    sqlite3_stmt *statement;
    NSLog(@"%@",sqlCommand);
    @try {
        if (sqlite3_prepare_v2(sqlite, [sqlCommand UTF8String], -1, &statement, nil) ==SQLITE_OK)
        {
            NSInteger index=1;
            NSString *sValue;
            
            for (sValue in selectionArgs) {
                sqlite3_bind_text(statement, index++, [sValue UTF8String], -1, nil);
                sValue = nil;
            }
            
            reval = [[NSMutableArray alloc]init];
            NSMutableDictionary *keyValue = nil;
            NSInteger count = 0;
//            NSString *column = nil;
            NSString *cValue = nil;
            
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                @try {
                    keyValue = [[NSMutableDictionary alloc] init];
                    
                    count = sqlite3_column_count(statement);
                    for (int i = 0; i < count; i++) {
//                        column = [MoneyDBUtils stringFromUTF8:(const char *)sqlite3_column_name(statement, i)];
                        cValue = [ZooDBUtil stringFromUTF8:(const char*)sqlite3_column_text(statement, i)];
                        
                        [keyValue setValue:cValue forKey:[NSString stringWithFormat:@"%d",i]];
                        
//                        column = nil;
                        cValue = nil;
                    }
                    [reval addObject:keyValue];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    if (keyValue != nil) {
                        keyValue = nil;
                    }
                    count = 0;
                }
            }
        }
        //        onCompletion();
    }
    @catch (NSException *exception) {
        NSLog(@"Raw error: %@",exception);
        onFailure();
    }
    @finally {
        if (statement != nil) {
            sqlite3_finalize(statement);
        }
    }
    
    return reval;
}

- (NSArray*)rawQuery:(NSString*)sqlCommand arg:(NSString*)selectionArg {
    
    NSMutableArray *reval;
    
    sqlite3_stmt *statement;
    @try {
        if (sqlite3_prepare_v2(sqlite, [sqlCommand UTF8String], -1, &statement, nil) == SQLITE_OK) {
            NSInteger index=1;
            
            sqlite3_bind_text(statement, index++, [selectionArg UTF8String], -1, nil);
            
            reval = [[NSMutableArray alloc]init];
            NSMutableDictionary *keyValue = nil;
            NSInteger count = 0;
            NSString *column = nil;
            NSString *cValue = nil;
            
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                @try {
                    keyValue = [[NSMutableDictionary alloc] init];
                    
                    count = sqlite3_column_count(statement);
                    for (int i = 0; i < count; i++) {
                        column = [ZooDBUtil stringFromUTF8:(const char*)sqlite3_column_name(statement,i)];
                        cValue = [ZooDBUtil stringFromUTF8:(const char*)sqlite3_column_text(statement, i)];
                        
                        [keyValue setValue:cValue forKey:column];
                        
                        column = nil;
                        cValue = nil;
                    }
                    [reval addObject:keyValue];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    if (keyValue != nil) {
                        keyValue = nil;
                    }
                    count = 0;
                }
            }
        }
//        onCompletion(reval);
    }
    @catch (NSException *exception) {
        NSLog(@"Raw error: %@",exception);
        onFailure();
    }
    @finally {
        if (statement != nil) {
            sqlite3_finalize(statement);
        }
    }
    
    return reval;
}


- (void)rawQueryTest:(NSString*)sqlCommand arg:(NSString*)selectionArg {
    NSMutableArray *reval;
    
    sqlite3_stmt *statement;
    NSLog(@"%@",sqlCommand);
    @try {
        if (sqlite3_prepare_v2(sqlite, [sqlCommand UTF8String], -1, &statement, nil) == SQLITE_OK) {
            NSInteger index=1;
            
            sqlite3_bind_text(statement, index++, [selectionArg UTF8String], -1, nil);
            
            reval = [[NSMutableArray alloc]init];
            NSMutableDictionary *keyValue = nil;
            NSInteger count = 0;
            NSString *column = nil;
            NSString *cValue = nil;


            while (sqlite3_step(statement) == SQLITE_ROW) {
                @try {
                    keyValue = [[NSMutableDictionary alloc] init];
                    
                    count = sqlite3_column_count(statement);
                    for (int i = 0; i < count; i++) {
                        column = [ZooDBUtil stringFromUTF8:(const char*)sqlite3_column_name(statement,i)];
                        cValue = [ZooDBUtil stringFromUTF8:(const char*)sqlite3_column_text(statement, i)];
                        
                        [keyValue setValue:cValue forKey:column];
                        
                        column = nil;
                        cValue = nil;
                    }
                    [reval addObject:keyValue];
                }
                @catch (NSException *exception) {

                }
                @finally {
                    if (keyValue != nil) {
                        keyValue = nil;
                    }
                    count = 0;
                }
            }
        }
        onCompletion(reval);
    }
    @catch (NSException *exception) {
        NSLog(@"Raw error: %@",exception);
        onFailure();
    }
    @finally {
        if (statement != nil) {
            sqlite3_finalize(statement);
        }
    }
}

#pragma mark - Return db path
+ (NSString *)dbPath:(NSString *)fileName {
    if (documentDir == nil) {
        documentDir = [[kDOCSFOLDER stringByAppendingPathComponent:fileName]copy];
        DebugLog(@"dbPath: :%@",documentDir);
    }
    return documentDir;
}

- (void)closeDB {
    sqlite3_close(sqlite);
    
}
@end
