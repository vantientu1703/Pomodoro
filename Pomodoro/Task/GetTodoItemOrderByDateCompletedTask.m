//
//  GetTodoItemOrderByDateCompletedTask.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/2/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "GetTodoItemOrderByDateCompletedTask.h"
#import "DBUtil.h"

@implementation GetTodoItemOrderByDateCompletedTask

- (NSMutableArray *) getTodoItemToDatbase:(MoneyDBController *)_moneyDBController {
    
    NSString *query = @"SELECT * FROM todos \
                        WHERE status = 1 AND isdeleted = 0 \
                        ORDER BY date_completed DESC";
    
    NSArray *arr = [_moneyDBController rawQueryWithCommand:query args:nil];
    
    NSMutableArray *arrTodoItem = [[NSMutableArray alloc] init];
    for (NSDictionary *todo in arr) {
        TodoItem *todoItem = [[TodoItem alloc] init];
        todoItem = [DBUtil dbItemToToDoItem:todo];
        [arrTodoItem addObject:todoItem];
    }
    return arrTodoItem;
}
@end
