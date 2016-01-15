//
//  GetTodoItemIsDeletedInProjectToDatabaseTask.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 12/1/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "GetTodoItemInProjectToDatabaseTask.h"
#import "DBUtil.h"


@implementation GetTodoItemInProjectToDatabaseTask

- (NSArray *) getTodoItemInProjectToDatabase:(MoneyDBController *)_moneyDBController whereID: (long) projectID {
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM projectmanage WHERE projectid = %ld", projectID];
    NSArray *arr = [_moneyDBController rawQueryWithCommand:query args:nil];
    
    NSMutableArray *arrProjects = [[NSMutableArray alloc] init];
    
    for (NSDictionary *project in arr) {
        
        ProjectManageItem *projectManageItem = [[ProjectManageItem alloc] init];
        projectManageItem = [DBUtil dbItemToProjectManageItem:project];
        [arrProjects addObject:projectManageItem];
    }
    
    return arrProjects;
}
@end
