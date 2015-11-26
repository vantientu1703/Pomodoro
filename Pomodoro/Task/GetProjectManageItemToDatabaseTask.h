//
//  GetProjectManageItemToDatabaseTask.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectManageItem.h"

@interface GetProjectManageItemToDatabaseTask : NSObject

- (NSMutableArray *) getProjectManageItemToDatabase: (MoneyDBController *) _moneyDBController;
@end
