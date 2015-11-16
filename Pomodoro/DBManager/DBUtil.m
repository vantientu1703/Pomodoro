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
    [dictionary setValue:[NSString stringWithFormat:@"%d",todoItem.isDelete] forKey:@"isdeleted"];
    [dictionary setValue:[NSString stringWithFormat:@"%f",[todoItem.dateCompleted timeIntervalSince1970]] forKey:@"date_completed"];
    [dictionary setValue:[NSString stringWithFormat:@"%f",[todoItem.dateDeleted timeIntervalSince1970]] forKey:@"date_deleted"];
    //[dictionary setValue:[NSString stringWithFormat:@"%ld", todoItem.todo_id] forKey:@"id"];
    
    return dictionary;
}

+ (TodoItem *) dbItemToToDoItem:(NSDictionary *)todo {
    
    TodoItem *todoItem = [TodoItem new];
    
    todoItem.todo_id = [todo [@"0"]longLongValue];
    todoItem.content = todo [@"1"];
    todoItem.status = [todo [@"2"]boolValue];
    todoItem.isDelete = [todo [@"3"]boolValue];
    todoItem.dateCompleted = [NSDate dateWithTimeIntervalSince1970:[todo [@"4"]doubleValue]];
    todoItem.dateDeleted = [NSDate dateWithTimeIntervalSince1970:[todo [@"5"]doubleValue]];
//    todoItem.date_complete = [todo [@"4"]]
    
    return todoItem;
}
@end
