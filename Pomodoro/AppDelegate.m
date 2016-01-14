//
//  AppDelegate.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "AppDelegate.h"
#import "MoneyDBController.h"
#import "SettingItem.h"
#import "AGPushNoteView.h"
#import "UpdateToDoItemToDatabase.h"
#import "MainScreen.h"
#import "DataSoundManager.h"

@interface AppDelegate ()

@property (nonatomic, strong) MoneyDBController *moneyDBController;
@property (nonatomic, strong) NSUserDefaults *shareUserDefaults;

@end

@implementation AppDelegate

{
    int seconds;
    int minutes;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
    _moneyDBController = [MoneyDBController getInstance];
    [_moneyDBController openDB:[NSString stringWithFormat:@"Pomodoro.sqlite"]];
    
    DataSoundManager *dataSoundManager = [DataSoundManager getSingleton];
    self.settingItem = [SettingItem new];
    self.timerNotificationcenterItem = [TimerNotificationcenterItem new];
    [self setupTimerNotificationCenterItem];
    
    
    return YES;
}
- (void) setupTimerNotificationCenterItem {
    _timerNotificationcenterItem.totalTime = _settingItem.timeWork * 60;
    _timerNotificationcenterItem.timeMinutes = _timerNotificationcenterItem.totalTime / 60;
    _timerNotificationcenterItem.isWorking = true;
    _timerNotificationcenterItem.totalWorking = 0;
    _timerNotificationcenterItem.totalLongBreaking = 0;
    _timerNotificationcenterItem.isRunTimer = nil;
    _timerNotificationcenterItem.stringStatusWorking = @"Working";
    NSUserDefaults *shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
    [shareUserDefaults setInteger:_timerNotificationcenterItem.timeMinutes forKey:@"key_time_minutes"];
    [shareUserDefaults setInteger:0 forKey:@"key_time_seconds"];
    [shareUserDefaults synchronize];
}
- (void) startStopTimer {
    if (_timerNotificationcenterItem.isRunTimer) {
        _timerNotificationcenterItem.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                              target:self
                                                                            selector:@selector(runningTimer)
                                                                            userInfo:nil
                                                                             repeats:YES];
    } else {
        [_timerNotificationcenterItem.timer invalidate];
    }
}

- (void) runningTimer { // khi đc gọi timer bắt đầu chạy và đếm lùi thời gian đc cài đặt.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KEY_START_TIMER
                                                        object:self];
    _timerNotificationcenterItem.totalTime --;
    _timerNotificationcenterItem.timeMinutes = _timerNotificationcenterItem.totalTime / 60;
    _timerNotificationcenterItem.timeSeconds = _timerNotificationcenterItem.totalTime - (_timerNotificationcenterItem.timeMinutes * 60);
    [_shareUserDefaults setInteger:_timerNotificationcenterItem.totalTime forKey:@"key_total_time"];
    
        if (_timerNotificationcenterItem.totalTime == 0) {
            if (_timerNotificationcenterItem.isWorking) {
                
                _timerNotificationcenterItem.totalWorking ++;
                _timerNotificationcenterItem.isWorking = false;
                if (_settingItem.switchOnOffLongBreak == 0) {
                    [self pushNotification:@"This is time to break"];
                    _timerNotificationcenterItem.stringStatusWorking = @"Breaking";
                    _timerNotificationcenterItem.totalTime = _settingItem.timeBreak * 60;
                } else {
                    if (_timerNotificationcenterItem.totalWorking > 0 && _timerNotificationcenterItem.totalWorking % _settingItem.frequency == 0) {
                        [self pushNotification:@"This is time to long break"];
                        _timerNotificationcenterItem.totalTime = _settingItem.timeLongBreak * 60;
                        _timerNotificationcenterItem.stringStatusWorking = @"Long Breaking";
                    } else {
                        [self pushNotification:@"This is time to break"];
                        _timerNotificationcenterItem.totalTime = _settingItem.timeBreak * 60;
                        _timerNotificationcenterItem.stringStatusWorking = @"Breaking";
                    }
                }
            } else if (!_timerNotificationcenterItem.isWorking) {
                
                [self pushNotification:@"This is time to work"];
                _timerNotificationcenterItem.isWorking = true;
                if (_timerNotificationcenterItem.totalWorking > 0 && _timerNotificationcenterItem.totalWorking % _settingItem.frequency == 0) {
                    _timerNotificationcenterItem.totalLongBreaking ++;
                    TodoItem *todoItem = [[TodoItem alloc] init];
                    todoItem = _timerNotificationcenterItem.todoItem;
                    int pomodoros = todoItem.pomodoros;
                    pomodoros ++;
                    todoItem.pomodoros = pomodoros;
                    _timerNotificationcenterItem.pomodoros = pomodoros;
                    UpdateToDoItemToDatabase *updateToDoItemToDatabase = [[UpdateToDoItemToDatabase alloc] initWithTodoItem: todoItem];
                    [updateToDoItemToDatabase doQuery:_moneyDBController];
                    //cell.labelPomodoros.text = [NSString stringWithFormat:@"Pomodoros : %d", todoItem.pomodoros];
                }
                _timerNotificationcenterItem.stringStatusWorking = @"Working";
                _timerNotificationcenterItem.totalTime = _settingItem.timeWork * 60;
            }
        }
}

- (void) pushNotification: (NSString *) stringNotification {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = stringNotification;
    localNotification.fireDate = [NSDate date];
    localNotification.soundName = @"chuongtit.mp3";
    //localNotification.applicationIconBadgeNumber = 1;
    localNotification.alertAction = @"Go on application";
    localNotification.category = @"Email";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo {
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSString *stringCheckTimerRunning = [_shareUserDefaults stringForKey:@"key_timer_running"];
    if ([stringCheckTimerRunning isEqualToString:@"running"] || [stringCheckTimerRunning isEqualToString:@"pause"] || [stringCheckTimerRunning isEqualToString:@"stop"] || [stringCheckTimerRunning isEqualToString:@"start"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidBecomeActive" object:nil];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSString *stringCheckTimerRunning = [_shareUserDefaults stringForKey:@"key_timer_running"];
    if ([stringCheckTimerRunning isEqualToString:@"running"] || [stringCheckTimerRunning isEqualToString:@"pause"] || [stringCheckTimerRunning isEqualToString:@"stop"] || [stringCheckTimerRunning isEqualToString:@"start"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidBecomeActive" object:nil];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    NSString *stringCheckTimerRunning = [_shareUserDefaults stringForKey:@"key_timer_running"];
    if ([stringCheckTimerRunning isEqualToString:@"running"] || [stringCheckTimerRunning isEqualToString:@"pause"] || [stringCheckTimerRunning isEqualToString:@"stop"] || [stringCheckTimerRunning isEqualToString:@"start"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidBecomeActive" object:nil];
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [_shareUserDefaults setObject:@"appisstop" forKey:@"keycheckappisrunning"];
}

@end
