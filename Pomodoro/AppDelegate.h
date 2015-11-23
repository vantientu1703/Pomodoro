//
//  AppDelegate.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingItem.h"
#import "TimerNotificationcenterItem.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SettingItem *settingItem;
// timerNotification
@property (nonatomic, strong) TimerNotificationcenterItem *timerNotificationcenterItem;
- (void) startStopTimer;
@end

