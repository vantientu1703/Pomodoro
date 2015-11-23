//
//  TimerNotificationcenterItem.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/16/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "TimerNotificationcenterItem.h"

@implementation TimerNotificationcenterItem

- (instancetype) init {
    
    self = [super init];
    if (self) {
        [self loadSettingTimerNotificationCenter];
    }
    return self;
}

- (void) loadSettingTimerNotificationCenter {
    
    [self setIsWorking:true];
    
//    if (![_stringTaskname isEqualToString:@""]) {
//        _stringTaskname = @"";
//    }
}












@end
