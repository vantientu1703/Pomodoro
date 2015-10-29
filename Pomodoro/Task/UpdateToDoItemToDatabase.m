//
//  UpdateToDoItemToDatabase.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/26/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "UpdateToDoItemToDatabase.h"
#import "DBUtil.h"



@interface UpdateToDoItemToDatabase () {
    TodoItem *_todoItem;
}

@end

@implementation UpdateToDoItemToDatabase

- (id)initWithTodoItem:(TodoItem*)todoItem {
    self = [super init];
    if (self) {
        _todoItem = todoItem;
    }
    return self;
}

- (void) doQuery:(MoneyDBController *)db {
    
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    
    [arr addObject:[NSString stringWithFormat:@"%ld", _todoItem.todo_id]];
    
    NSInteger i = [db update:todos data:[DBUtil ToDoItemToDBItem:_todoItem] whereClause:@"id = ?" whereArgs:arr];
    
    if ((i != -1)) {
        
        DebugLog(@"Update database accessesfully");
    } else {
        
        DebugLog(@"Update not query");
    }
}
@end
