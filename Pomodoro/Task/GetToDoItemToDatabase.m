//
//  GetToDoItemToDatabase.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/26/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "GetToDoItemToDatabase.h"
#import "DBUtil.h"

@implementation GetToDoItemToDatabase


+ (NSMutableArray *) getTodoItemToDatabase:(MoneyDBController *)moneyDBController where: (NSArray *) arrays {
    
    NSMutableArray *arrTodo = [[NSMutableArray alloc] init];
    
    NSString *query = @"SELECT id,content,status,isdeleted FROM todos \
                        WHERE status = ? AND isdeleted = ?";
    
    NSArray *arr = [moneyDBController rawQueryWithCommand:query args:arrays];
    
    
    DebugLog(@"arr : %@", arr);
    
    for (NSDictionary *todo in arr) {
        
        TodoItem *todoItem = [TodoItem new];
        
        todoItem = [DBUtil dbItemToToDoItem:todo];
        
        DebugLog(@"1 phan tu: %@",[todo objectForKey:@"0"]);
        [arrTodo addObject:todoItem];
    }
    
    return arrTodo;
}
@end

