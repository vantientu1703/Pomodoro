//
//  DBUtil.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TodoItem.h"
#import "MoneyDBController.h"

@interface DBUtil : NSObject

+ (NSDictionary *) ToDoItemToDBItem: (TodoItem *) todoItem;
+ (TodoItem *) dbItemToToDoItem: (NSDictionary *) todoItem;
@end
