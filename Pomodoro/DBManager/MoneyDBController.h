//
//  MoneyDBController.h
//  Money Lover
//
//  Created by Pham Quang Thang on 11/23/12.
//  Copyright (c) 2012 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ZooDBUtil.h"

@interface MoneyDBController : NSObject

@property (nonatomic,assign) sqlite3 *sqlite;
@property (nonatomic,copy) void (^onCompletion)(id object);
@property (nonatomic,copy) void (^onFailure)();

+ (MoneyDBController *)getInstance;
+ (NSString *)dbPath:(NSString*)fileName;

- (sqlite3*)openDB:(NSString*)fileName;

- (void)closeDB;

- (long)insert:(NSString*)table_name data:(NSDictionary *)data;

- (NSInteger)update:(NSString*)table_name data:(NSDictionary*)data whereClause:(NSString*)clause whereArgs:(NSArray*)args;

- (NSInteger)delete:(NSString*)table_name conditionString:(NSString*)conditionString conditionValue:(NSArray*)conditionValue;

- (NSArray*)rawQuery:(NSString*)sqlCommand args:(NSArray*)selectionArgs;

- (NSArray*)rawQuery:(NSString*)sqlCommand arg:(NSString*)selectionArg;

- (NSArray*)rawQueryWithCommand:(NSString*)sqlCommand args:(NSArray*)selectionArgs;
@end
