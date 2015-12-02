//
//  DeleteProjectManageToDatabaseTask.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/27/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeleteProjectManageToDatabaseTask : NSObject

- (instancetype) initWithProjectManage: (ProjectManageItem *) projectManageItem;
- (void) doQuery: (MoneyDBController *) _moneyDBController;
@end
