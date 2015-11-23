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
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault setInteger:25 forKey:keyTimeWork];
//    [userDefault setInteger:5 forKey:keyTimeBreak];
//    [userDefault setInteger:15 forKey:keyTimeLongBreak];
//    [userDefault setInteger:4 forKey:keyFrequency];
//    [userDefault setInteger:0 forKey:keyIsChanged];
//    [userDefault setInteger:-1 forKey:keyIndexPathForCell];
    //[userDefault setInteger:0 forKey:keyisActive];
    
    [self setTimeWork:(int)[userDefault integerForKey:keyTimeWork]];
    if (self.timeWork == 0) {
        [userDefault setInteger:25 forKey:keyTimeWork];
    }
    
    [self setTimeBreak:(int)[userDefault integerForKey:keyTimeBreak]];
    if (self.timeBreak == 0) {
        [userDefault setInteger:5 forKey:keyTimeBreak];
    }
    
    [self setTimeLongBreak: (int)[userDefault integerForKey:keyTimeLongBreak]];
    if (self.timeLongBreak == 0) {
        [userDefault setInteger:15 forKey:keyTimeLongBreak];
    }
    [self setFrequency:(int) [userDefault integerForKey:keyFrequency]];
    if (self.frequency == 0) {
        [userDefault setInteger:4 forKey:keyFrequency];
    }
    [self setSwitchOnOffLongBreak:(int)[userDefault integerForKey:keySwitchOnOffLongBreak]];
    
    [self setIsActive:(BOOL)[userDefault integerForKey:keyisActive]];
    
    [self setIsChanged:(BOOL)[userDefault integerForKey:keyIsChanged]];
    if (self.isChanged != 0) {
        [userDefault setInteger:0 forKey:keyIsChanged];
    }
    [self setIndexPathForCell:(int)[userDefault integerForKey:keyIndexPathForCell]];
    if (self.indexPathForCell != -1) {
        [userDefault setInteger:-1 forKey:keyIndexPathForCell];
    }
}












@end
