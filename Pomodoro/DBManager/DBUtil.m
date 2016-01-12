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
    [dictionary setValue:[NSString stringWithFormat:@"%ld", todoItem.projectID] forKey:@"projectid"];
    [dictionary setValue:[NSString stringWithFormat:@"%d", todoItem.pomodoros] forKey:@"pomodoros"];
    [dictionary setValue:[NSString stringWithFormat:@"%d", todoItem.priority] forKey:@"priority"];
    [dictionary setValue:[NSString stringWithFormat:@"%d", todoItem.enableAlarm] forKey:@"enablealarm"];
    [dictionary setValue:[NSString stringWithFormat:@"%f", [todoItem.timeAlarm timeIntervalSince1970]] forKey:@"timealarm"];
    [dictionary setValue:[NSString stringWithFormat:@"%d", todoItem.jingtoneID] forKey:@"alarmid"];
    
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
    todoItem.projectID = [todo [@"6"]longLongValue];
    todoItem.pomodoros = [todo [@"7"]intValue];
    todoItem.priority = [todo [@"8"]intValue];
    todoItem.enableAlarm = [todo [@"9"]boolValue];
    todoItem.timeAlarm = [NSDate dateWithTimeIntervalSince1970:[todo [@"10"]doubleValue]];
    todoItem.jingtoneID =  [todo [@"11"]intValue];
    
    return todoItem;
}

+ (NSDictionary *) projectManageItemToDBItem:(ProjectManageItem *)projectManage {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:[NSString stringWithFormat:@"%@",projectManage.projectName] forKey:@"projectname"];
    [dictionary setValue:[NSString stringWithFormat:@"%f",[projectManage.startDate timeIntervalSince1970]] forKey:@"startdate"];
    [dictionary setValue:[NSString stringWithFormat:@"%f",[projectManage.endDate timeIntervalSince1970]] forKey:@"enddate"];
    [dictionary setValue:[NSString stringWithFormat:@"%@", projectManage.projectDescription] forKey:@"description"];
    
    return dictionary;
}

+ (ProjectManageItem *) dbItemToProjectManageItem:(NSDictionary *)projectManage {
    
    ProjectManageItem *projectManageItem = [[ProjectManageItem alloc] init];
    
    projectManageItem.projectID = [projectManage [@"0"]longLongValue];
    projectManageItem.projectName = projectManage [@"1"];
    projectManageItem.startDate = [NSDate dateWithTimeIntervalSince1970:[projectManage [@"2"]doubleValue]];
    projectManageItem.endDate = [NSDate dateWithTimeIntervalSince1970:[projectManage [@"3"]doubleValue]];
    projectManageItem.projectDescription = projectManage [@"4"];
    
    return projectManageItem;
}

+ (NSDictionary *) dataChartToDBItem:(DataChartItem *)dataChartItem {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:[NSString stringWithFormat:@"%f",[dataChartItem.monthYear timeIntervalSince1970]] forKey:@"monthyear"];
    
    return dictionary;
}

+ (DataChartItem *) dbItemToDataChartItem:(NSDictionary *)dataChart {
    DataChartItem *dataChartItem = [[DataChartItem alloc] init];
    
    dataChartItem.dataChart_ID = [dataChart [@"id"]longLongValue];
    dataChartItem.monthYear = [NSDate dateWithTimeIntervalSince1970:[dataChart [@"monthyear"]doubleValue]];
    
    return dataChartItem;
}

























@end
