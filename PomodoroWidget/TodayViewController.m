//
//  TodayViewController.m
//  PomodoroWidget
//
//  Created by Văn Tiến Tú on 12/19/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
//#import "TimerNotificationcenterItem.h"

@interface TodayViewController () <NCWidgetProviding>


@property (weak, nonatomic) IBOutlet UILabel *labelMinutes;
@property (weak, nonatomic) IBOutlet UILabel *labelSeconds;
@property (weak, nonatomic) IBOutlet UILabel *labelStatusWorking;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (nonatomic, strong) NSUserDefaults *shareUserDefaults;
@end

@implementation TodayViewController
{
    NSTimer *timer;
    
    int totalTime;
    int timeWork;
    int timeBreak;
    int timeLongBreak;
    int frequency;
    int timeMinutes;
    int timeSeconds;
    int totalWorking;
    int enableLongBreak;
    int pomodoro;
    
    NSString *statusWork;
    
    BOOL isRunning;
    BOOL isWorking;
}

- (void) viewWillAppear:(BOOL)animated {
    _shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
    
    timeMinutes = (int)[_shareUserDefaults integerForKey:@"key_time_minutes"];
    timeSeconds = (int)[_shareUserDefaults integerForKey:@"key_time_seconds"];
    [self updateLabel];
}
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    _shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
    _segmentControl.selectedSegmentIndex = -1;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                             target:self
                                           selector:@selector(updateLabel)
                                           userInfo:nil
                                            repeats:true];
    completionHandler(NCUpdateResultNewData);
}
- (IBAction)segmentControlOnClicked:(id)sender {
    
    if (_segmentControl.selectedSegmentIndex == 0) {
        
        BOOL isRunTimer;
        isRunTimer = [_shareUserDefaults boolForKey:@"key_is_run_timer"];
        if (isRunTimer) {
            [_shareUserDefaults setObject:@"pause" forKey:@"key_timer_running"];
            [_shareUserDefaults setBool:false forKey:@"key_is_run_timer"];
            _segmentControl.selectedSegmentIndex = -1;
            [_segmentControl setTitle:@"Start" forSegmentAtIndex:0];
        } else if(!isRunTimer){
            [_shareUserDefaults setObject:@"start" forKey:@"key_timer_running"];
            [_shareUserDefaults setBool:true forKey:@"key_is_run_timer"];
            _segmentControl.selectedSegmentIndex = -1;
            [_segmentControl setTitle:@"Pause" forSegmentAtIndex:0];
        }
        NSURL *url = [NSURL URLWithString:@"pomodoro://"];
        [self.extensionContext openURL:url completionHandler:^(BOOL success) {}];

    } else if (_segmentControl.selectedSegmentIndex == 1){
        _shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
        _segmentControl.selectedSegmentIndex = -1;
        [_shareUserDefaults setBool:false forKey:@"key_is_run_timer"];
        [_shareUserDefaults setObject:@"stop" forKey:@"key_timer_running"];
        
        //timeWork = (int) [_shareUserDefaults integerForKey:@"key_time_work"];
        //timeSeconds = 0;
        NSURL *url = [NSURL URLWithString:@"pomodoro://"];
        [self.extensionContext openURL:url completionHandler:^(BOOL success) {}];
    }
}
- (void) updateLabel {
    
    NSString *stringMinutes;
    NSString *stringSeconds;
    NSString *stringStatusWorking;
    
    BOOL isRunTimer;
    _shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
    isRunTimer = [_shareUserDefaults boolForKey:@"key_is_run_timer"];
    //_labelCheck.text = [NSString stringWithFormat:@"%d", [_shareUserDefaults boolForKey:@"key_is_run_timer"]];
    
    if (isRunTimer) {
        _segmentControl.selectedSegmentIndex = - 1;
        [_segmentControl setTitle:@"Pause" forSegmentAtIndex:0];
    } else {
        _segmentControl.selectedSegmentIndex = - 1;
        [_segmentControl setTitle:@"Start" forSegmentAtIndex:0];
    }
    
    stringStatusWorking = [_shareUserDefaults objectForKey:@"key_status_working"];
    _labelStatusWorking.text = stringStatusWorking;
    
    timeMinutes = (int)[_shareUserDefaults integerForKey:@"key_time_minutes"];
    timeSeconds = (int)[_shareUserDefaults integerForKey:@"key_time_seconds"];
    
    if (timeSeconds < 10) {
        stringSeconds = [NSString stringWithFormat:@"0%d", timeSeconds];
    } else {
        stringSeconds = [NSString stringWithFormat:@"%d", timeSeconds];
    }
    if (timeMinutes < 10) {
        stringMinutes = [NSString stringWithFormat:@"0%d", timeMinutes];
    } else {
        stringMinutes = [NSString stringWithFormat:@"%d", timeMinutes];
    }
    _labelMinutes.text = stringMinutes;
    _labelSeconds.text = stringSeconds;
}
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    self.preferredContentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 120);
}
- (UIEdgeInsets) widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return  UIEdgeInsetsZero;
}

@end
