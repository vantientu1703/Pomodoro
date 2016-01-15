//
//  GetTodoItemIsDeletedFollowProjectIDToDatabaseTask.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 1/16/16.
//  Copyright © 2016 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetTodoItemIsDeletedFollowProjectIDToDatabaseTask : NSObject

- (NSMutableArray *) getTodoItemToDatabase: (MoneyDBController *) moneyDBController whereProjectID: (int) projectID;
@end
