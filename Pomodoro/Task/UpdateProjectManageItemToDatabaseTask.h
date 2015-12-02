//
//  UpdateProjectManageItemToDatabaseTask.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/26/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateProjectManageItemToDatabaseTask : NSObject

- (instancetype) initWithProjectManageItem : (ProjectManageItem *) project;
- (void) doQuery: (MoneyDBController *) _moneyDBCotroller;

@end
