//
//  GetTodoItemsFollowPriorityToDatabaseTask.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 12/7/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetTodoItemsFollowPriorityToDatabaseTask : NSObject

- (NSMutableArray *) getTodoItemsFollowPriorityToDatabaseTask: (MoneyDBController *) _moneyDBController withPriority: (NSArray *) arrPriority;
@end
