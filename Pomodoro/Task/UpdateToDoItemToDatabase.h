//
//  UpdateToDoItemToDatabase.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/26/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoneyDBController.h"
#import "TodoItem.h"

@interface UpdateToDoItemToDatabase : NSObject

- (id)initWithTodoItem:(TodoItem*)todoItem;
- (void) doQuery: (MoneyDBController *) db ;

@end
