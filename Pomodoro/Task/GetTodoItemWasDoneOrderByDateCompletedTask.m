//
//  GetTodoItemOrderByDateCompletedTask.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/2/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "GetTodoItemWasDoneOrderByDateCompletedTask.h"
#import "DBUtil.h"

@implementation GetTodoItemWasDoneOrderByDateCompletedTask

- (NSMutableArray *) getTodoItemToDatbase:(MoneyDBController *)_moneyDBController where:(NSArray *)args {
    
    NSString *query = @"SELECT * FROM todos \
                        WHERE status = 1 AND isdeleted = 0 AND projectid = ?\
                        ORDER BY date_completed DESC";
    
    NSArray *arr = [_moneyDBController rawQueryWithCommand:query args:args];
    
    NSMutableArray *arrTodoItem = [[NSMutableArray alloc] init];
    for (NSDictionary *todo in arr) {
        TodoItem *todoItem = [[TodoItem alloc] init];
        todoItem = [DBUtil dbItemToToDoItem:todo];
        [arrTodoItem addObject:todoItem];
    }
    return arrTodoItem;
}
@end
