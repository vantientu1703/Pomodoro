//
//  GetTodoItemIsDeletedInProjectToDatabaseTask.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 12/1/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetTodoItemIsDeletedInProjectToDatabaseTask : NSObject

- (NSArray *) getTodoItemIsDeletedInProjectToDatabase: (MoneyDBController *) _moneyDBController whereID: (long) projectID;
@end
