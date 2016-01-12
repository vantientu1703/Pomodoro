//
//  SettingItem.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/13/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingItem : NSObject

@property (nonatomic, assign) int timeWork;
@property (nonatomic, assign) int timeBreak;
@property (nonatomic, assign) int timeLongBreak;
@property (nonatomic, assign) int frequency;
@property (nonatomic, assign) int switchOnOffLongBreak;
@property (nonatomic, assign) int indexPathRow;
@property (nonatomic, assign) int indexPathSection;
@property (nonatomic, assign) int indexPathRowMenu;
@property (nonatomic, assign) int indexPriority;

@property (nonatomic, assign) long projectID;

@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL isChanged;
@property (nonatomic, assign) BOOL isSound;
@property (nonatomic, assign) BOOL isStartupApp;

@property (nonatomic, strong) NSString *projectName;
@property (nonatomic, strong) TodoItem *todoItem;

@end
