//
//  GetToDoItemToDatabase.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/26/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "GetToDoItemToDatabase.h"
#import "DBUtil.h"

@implementation GetToDoItemToDatabase


+ (NSMutableArray *) getTodoItemToDatabase:(MoneyDBController *)moneyDBController where: (NSArray *) arrays {
    
    NSMutableArray *arrTodo = [[NSMutableArray alloc] init];
    
    NSString *query = @"SELECT id,content,status,isdeleted,date_completed,date_deleted FROM todos \
                        WHERE status = ? AND isdeleted = ?";
    NSArray *arr = [moneyDBController rawQueryWithCommand:query args:arrays];
    
    for (NSDictionary *todo in arr) {
        
        TodoItem *todoItem = [TodoItem new];
        todoItem = [DBUtil dbItemToToDoItem:todo];
        [arrTodo addObject:todoItem];
    }
    return arrTodo;
}
@end

