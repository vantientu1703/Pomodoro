//
//  GetTodoItemIsDeletedFollowProjectIDToDatabaseTask.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 1/16/16.
//  Copyright © 2016 ZooStudio. All rights reserved.
//

#import "GetTodoItemIsDeletedFollowProjectIDToDatabaseTask.h"

@implementation GetTodoItemIsDeletedFollowProjectIDToDatabaseTask

- (NSMutableArray *) getTodoItemToDatabase:(MoneyDBController *)moneyDBController whereProjectID:(int)projectID {
    
    NSMutableArray *arrTodo = [[NSMutableArray alloc] init];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM todos \
                        WHERE isdeleted = 1 AND projectid = %d\
                        ORDER BY date_deleted DESC", projectID];
    NSArray *arr = [moneyDBController rawQueryWithCommand:query args:nil];
    for (NSDictionary *todo in arr) {
        
        TodoItem *todoItem = [TodoItem new];
        todoItem = [DBUtil dbItemToToDoItem:todo];
        [arrTodo addObject:todoItem];
    }
    return arrTodo;
}
@end
