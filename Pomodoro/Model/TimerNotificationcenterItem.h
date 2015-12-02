//
//  TimerNotificationcenterItem.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/16/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TimerNotificationcenterItem : NSObject

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isWorking;
@property (nonatomic, strong) NSString *stringStatusWorking;
@property (nonatomic, assign) int timeMinutes;
@property (nonatomic, assign) int timeSeconds;
@property (nonatomic, assign) BOOL isRunTimer;
@property (nonatomic, assign) int totalWorking;
@property (nonatomic, assign) int totalLongBreaking;
@property (nonatomic, assign) int totalTime;
@property (nonatomic, strong) NSString *stringTaskname;
@property (nonatomic, strong) TodoItem *todoItem;
@property (nonatomic, assign) int pomodoros;
@end
