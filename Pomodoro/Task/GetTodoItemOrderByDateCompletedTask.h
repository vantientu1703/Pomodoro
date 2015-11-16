//
//  GetTodoItemOrderByDateCompletedTask.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/2/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetTodoItemOrderByDateCompletedTask : NSObject

- (NSMutableArray *) getTodoItemToDatbase: (MoneyDBController *) _moneyDBController;
@end
