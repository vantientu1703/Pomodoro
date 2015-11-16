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
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL isChanged;

@end
