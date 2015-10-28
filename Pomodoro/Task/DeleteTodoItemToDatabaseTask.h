//
//  DeleteTodoItemToDatabaseTask.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/27/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TodoItem.h"
#import "MoneyDBController.h"

@interface DeleteTodoItemToDatabaseTask : NSObject

- (instancetype) initWithTodoItem: (TodoItem *) todoItem;
- (void) doQuery: (MoneyDBController *) db;
@end
