//
//  GetTodoItemIsDeletedTask.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/31/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TodoItem.h"

@interface GetTodoItemIsDeletedTask : NSObject

- (NSMutableArray *) getTodoItemToDatabase: (MoneyDBController *) moneyDBController;

@end
