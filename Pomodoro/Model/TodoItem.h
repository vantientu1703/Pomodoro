//
//  TodoItem.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoItem : NSObject

@property (nonatomic, assign) long todo_id ;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, assign) BOOL status;

@property (nonatomic, assign) BOOL isDelete;

@property (nonatomic, strong) NSDate *dateCompleted;

@property (nonatomic, strong) NSDate *dateDeleted;

@end
