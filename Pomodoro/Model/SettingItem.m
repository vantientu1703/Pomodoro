//
//  SettingItem.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/13/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "SettingItem.h"

@implementation SettingItem

- (instancetype) init {
    self = [super init];
    if (self) {
        [self loadSetting];
    }
    return self;
}

- (void) setTimeWork:(int)timeWork {
    _timeWork = timeWork;
}

- (void) setTimeBreak:(int)timeBreak {
    _timeBreak = timeBreak;
}

- (void) setTimeLongBreak:(int)timeLongBreak {
    _timeLongBreak = timeLongBreak;
}

- (void) setFrequency:(int)frequency {
    _frequency = frequency;
}

- (void) setSwitchOnOffLongBreak:(int)switchOnOffLongBreak {
    _switchOnOffLongBreak = switchOnOffLongBreak;
}

- (void) loadSetting {
    
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
//    [userDefault setInteger:25 forKey:keyTimeWork];
//    [userDefault setInteger:5 forKey:keyTimeBreak];
//    [userDefault setInteger:15 forKey:keyTimeLongBreak];
//    [userDefault setInteger:4 forKey:keyFrequency];
//    [userDefault setInteger:0 forKey:keyIsChanged];
//    [userDefault setInteger:-1 forKey:keyIndexPathForCell];
    //[userDefault setInteger:0 forKey:keyisActive];
    
    [self setTimeWork:(int)[userDefault integerForKey:KEY_TIME_WORK]];
    if (self.timeWork == 0) {
        [userDefault setInteger:25 forKey:KEY_TIME_WORK];
        [self setTimeWork:25];
    }
    
    [self setTimeBreak:(int)[userDefault integerForKey:KEY_TIME_BREAK]];
    if (self.timeBreak == 0) {
        [userDefault setInteger:5 forKey:KEY_TIME_BREAK];
        [self setTimeBreak:5];
    }
    
    [self setTimeLongBreak: (int)[userDefault integerForKey:KEY_TIME_LONG_BREAK]];
    if (self.timeLongBreak == 0) {
        [userDefault setInteger:15 forKey:KEY_TIME_LONG_BREAK];
        [self setTimeLongBreak:15];
    }
    [self setFrequency:(int) [userDefault integerForKey:KEY_FREQUENCY]];
    if (self.frequency == 0) {
        [userDefault setInteger:4 forKey:KEY_FREQUENCY];
        [self setFrequency:4];
    }
    [self setSwitchOnOffLongBreak:(int)[userDefault integerForKey:KEY_SWITCH_ONOFF_LONG_BREAK]];
    
    [self setIsActive:(BOOL)[userDefault integerForKey:KEY_IS_ACTIVE]];
    
    [self setIsChanged:(BOOL)[userDefault integerForKey:KEY_IS_CHANGED]];
    if (self.isChanged != 0) {
        [userDefault setInteger:0 forKey:KEY_IS_CHANGED];
        [self setIsChanged:false];
    }
    [self setIndexPathRow:(int)[userDefault integerForKey:KEY_INDEXPATH_ROW]];
    if (self.indexPathRow != -1) {
        [userDefault setInteger:-1 forKey:KEY_INDEXPATH_ROW];
        [self setIndexPathRow:-1];
    }
    
    [self setIndexPathSection:(int)[userDefault integerForKey:KEY_INDEXPATH_SECTION]];
    if (self.indexPathSection != -1) {
        [userDefault setInteger:-1 forKey:KEY_INDEXPATH_SECTION];
        [self setIndexPathSection:-1];
    }
    
    
    [self setIsSound:(BOOL)[userDefault integerForKey:KEY_IS_SOUND]];
    
    NSArray *arr = [userDefault objectForKey:KEY_PROCJECT_NAME];
    if (arr.count != 0) {
        [self setProjectName:[NSString stringWithFormat:@"%@",[arr objectAtIndex:0]]];
    }
    
    [self setIsStartupApp:(BOOL)[userDefault boolForKey:KEY_START_APP]];
    if (self.isStartupApp == 0) {
        [self setProjectID:2];
    } else {
        [self setProjectID:(long)[userDefault integerForKey:KEY_PROJECT_ID]];
    }
    [self setIndexPriority:(int)[userDefault integerForKey:KEY_INDEX_PRIORITY]];
    if (self.indexPriority == 0) {
        [userDefault setInteger:1 forKey:KEY_INDEX_PRIORITY];
        [self setIndexPriority:1];
    }
    [self setIndexPathRowMenu:(int)[userDefault integerForKey:KEY_INDEXPATH_ROW_MENU]];
    [self setTodoItem:(TodoItem *)[userDefault objectForKey:KEY_TODO_ITEM]];
    [self setIsCheckTimerRunning:(BOOL)[userDefault boolForKey:@"key_is_check_timer_running"]];
}












@end
