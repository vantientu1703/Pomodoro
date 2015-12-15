//
//  GetTodoItemsFollowPriorityToDatabaseTask.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 12/7/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "GetTodoItemsFollowPriorityToDatabaseTask.h"

@implementation GetTodoItemsFollowPriorityToDatabaseTask

- (NSMutableArray *) getTodoItemsFollowPriorityToDatabaseTask:(MoneyDBController *)_moneyDBController withPriority:(NSArray *)arrPriority {
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM todos WHERE status = 0 AND isdeleted = 0 AND priority = ? AND projectid = ?"];
    
    NSArray *arr = [_moneyDBController rawQueryWithCommand:query args:arrPriority];
    NSMutableArray *arrTodos = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr) {
        TodoItem *todoItem = [[TodoItem alloc] init];
        todoItem = [DBUtil dbItemToToDoItem:dict];
        [arrTodos addObject:todoItem];
    }
    return arrTodos;
}
@end
