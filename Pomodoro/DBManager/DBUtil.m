//
//  DBUtil.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "DBUtil.h"
#import "MoneyDBController.h"
#import "TodoItem.h"

@implementation DBUtil

+ (NSDictionary *) ToDoItemToDBItem: (TodoItem *) todoItem {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:[NSString stringWithFormat:@"%@",todoItem.content] forKey:@"content"];
    [dictionary setValue:[NSString stringWithFormat:@"%d", todoItem.status] forKey:@"status"];
    //[dictionary setValue:[NSString stringWithFormat:@"%ld", todoItem.todo_id] forKey:@"id"];
    
    return dictionary;
}

+ (TodoItem *) dbItemToToDoItem:(NSDictionary *)todo {
    
    TodoItem *todoItem = [TodoItem new];
    
    todoItem.todo_id = [todo [@"0"]longLongValue];
    todoItem.content = todo [@"1"];
    todoItem.status = [todo [@"2"]boolValue];
    
    return todoItem;
}
@end
