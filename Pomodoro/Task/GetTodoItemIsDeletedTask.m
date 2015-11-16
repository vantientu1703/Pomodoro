//
//  GetTodoItemIsDeletedTask.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/31/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "GetTodoItemIsDeletedTask.h"
#import "DBUtil.h"
@implementation GetTodoItemIsDeletedTask

- (NSMutableArray *) getTodoItemToDatabase: (MoneyDBController *) moneyDBController {
    
    NSMutableArray *arrTodo = [[NSMutableArray alloc] init];
    NSString *query = @"SELECT * FROM todos \
                        WHERE isdeleted = 1 \
                        ORDER BY date_deleted DESC";
    NSArray *arr = [moneyDBController rawQueryWithCommand:query args:nil];
    for (NSDictionary *todo in arr) {
        
        TodoItem *todoItem = [TodoItem new];
        todoItem = [DBUtil dbItemToToDoItem:todo];
        [arrTodo addObject:todoItem];
    }
    return arrTodo;
}
@end
