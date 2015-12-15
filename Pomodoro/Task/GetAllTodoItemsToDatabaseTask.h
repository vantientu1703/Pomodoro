//
//  GetAllTodoItemsToDatabaseTask.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 12/7/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetAllTodoItemsToDatabaseTask : NSObject

- (NSMutableArray *) getAllTodoItemsToDatabase: (MoneyDBController *) _moneyDBController;
@end
