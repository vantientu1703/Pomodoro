//
//  GetToDoItemToDatabase.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/26/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoneyDBController.h"
#import "TodoItem.h"

@interface GetToDoItemToDatabase : NSObject

+ (NSMutableArray *) getTodoItemToDatabase: (MoneyDBController *) moneyDBController where: (NSArray *) arrays;

@end
