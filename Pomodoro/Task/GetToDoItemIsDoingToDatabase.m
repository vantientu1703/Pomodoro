//
//  GetToDoItemToDatabase.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/26/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "GetToDoItemIsDoingToDatabase.h"
#import "DBUtil.h"

@implementation GetToDoItemIsDoingToDatabase


+ (NSMutableArray *) getTodoItemToDatabase:(MoneyDBController *)moneyDBController where: (NSArray *) arrays {
    
    NSMutableArray *arrTodo = [[NSMutableArray alloc] init];
    
    NSString *query = @"SELECT * FROM todos \
                        WHERE status = 0 AND isdeleted = 0 AND projectid = ?";
    NSArray *arr = [moneyDBController rawQueryWithCommand:query args:arrays];
    
    for (NSDictionary *todo in arr) {
        
        TodoItem *todoItem = [TodoItem new];
        todoItem = [DBUtil dbItemToToDoItem:todo];
        [arrTodo addObject:todoItem];
    }
    return arrTodo;
}
@end

