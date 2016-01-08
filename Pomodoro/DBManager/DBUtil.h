//
//  DBUtil.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TodoItem.h"
#import "MoneyDBController.h"
#import "ProjectManageItem.h"
#import "DataChartItem.h"
@interface DBUtil : NSObject

+ (NSDictionary *) ToDoItemToDBItem: (TodoItem *) todoItem;
+ (TodoItem *) dbItemToToDoItem: (NSDictionary *) todoItem;
+ (NSDictionary *) projectManageItemToDBItem: (ProjectManageItem *) projectManage;
+ (ProjectManageItem *) dbItemToProjectManageItem: (NSDictionary *) projectManage;
+ (NSDictionary *) dataChartToDBItem: (DataChartItem *) dataChartItem;
+ (DataChartItem *) dbItemToDataChartItem: (NSDictionary *) dataChart;
@end
