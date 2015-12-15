//
//  GetAllTodoItemsToDatabaseTask.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 12/7/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "GetAllTodoItemsToDatabaseTask.h"

@implementation GetAllTodoItemsToDatabaseTask
- (NSMutableArray *) getAllTodoItemsToDatabase:(MoneyDBController *)_moneyDBController {
    
    NSString *query = @"SELECT * FROM todos WHERE status = 0 AND isdeleted = 0";
    NSArray *arr = [_moneyDBController rawQueryWithCommand:query args:nil];
    
    NSMutableArray *arrTodos = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in arr) {
        TodoItem *todoItem = [[TodoItem alloc] init];
        todoItem = [DBUtil dbItemToToDoItem:dict];
        [arrTodos addObject:todoItem];
    }
    return arrTodos;
}
@end
