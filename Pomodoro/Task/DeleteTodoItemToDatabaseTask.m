//
//  DeleteTodoItemToDatabaseTask.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/27/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "DeleteTodoItemToDatabaseTask.h"
#import "DBUtil.h"

@implementation DeleteTodoItemToDatabaseTask
{
    TodoItem *_todoItem;
}
- (instancetype) initWithTodoItem:(TodoItem *)todoItem {
    
    self = [super init];
    
    if (self) {
        _todoItem = todoItem;
    }
    return self;
}

- (void) doQuery:(MoneyDBController *)db {
    
    NSString *todoID = [NSString stringWithFormat:@"%ld", _todoItem.todo_id];
    
    NSArray *arr = [[NSArray alloc] initWithObjects:todoID, nil];
    
    NSInteger i = [db delete:todos conditionString:@"id = ?" conditionValue:arr];
    
    if (i != -1) {
        
        DebugLog(@"Delete was execute successfully");
    } else {
        
        DebugLog(@"Not query to database");
    }
}
@end
