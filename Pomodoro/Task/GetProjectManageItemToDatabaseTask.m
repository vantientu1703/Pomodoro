//
//  GetProjectManageItemToDatabaseTask.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "GetProjectManageItemToDatabaseTask.h"
#import "DBUtil.h"
@implementation GetProjectManageItemToDatabaseTask

- (NSMutableArray *) getProjectManageItemToDatabase:(MoneyDBController *) _moneyDBController {
    
    NSString *query = @"SELECT projectid,projectname,startdate,enddate,description \
                        FROM projectmanage";
    
    NSArray *arr = [_moneyDBController rawQueryWithCommand:query args:nil];
    
    NSMutableArray *arrProjectManageItem = [[NSMutableArray alloc] init];
    for (NSDictionary *projectManage in arr) {
        
        ProjectManageItem *projectManageItem = [ProjectManageItem new];
        projectManageItem = [DBUtil dbItemToProjectManageItem:projectManage];
        [arrProjectManageItem addObject:projectManageItem];
    }
    
    return arrProjectManageItem;
}
@end
