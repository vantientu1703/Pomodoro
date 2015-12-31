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
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UILabel *labelStatusWorking;




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
    
    if ([_shareUserDefaults boolForKey:@"key_is_changed_from_containingapp"] || [[_shareUserDefaults stringForKey:@"key_timer_running"] isEqualToString:@"stop_containing_app"]) {
        [timer invalidate];
        [_shareUserDefaults setBool:false forKey:@"key_is_changed_from_containingapp"];
        [_shareUserDefaults setObject:@"" forKey:@"key_timer_ruuning"];
        
        timeWork = (int) [_shareUserDefaults integerForKey:@"key_time_work"];
        timeBreak = (int) [_shareUserDefaults integerForKey:@"key_time_break"];
        timeLongBreak = (int) [_shareUserDefaults integerForKey:@"key_time_longbreak"];
        frequency = (int) [_shareUserDefaults integerForKey:@"key_frequency"];
        timeMinutes = timeWork;
        timeSeconds = 0;
        
        totalTime = timeWork * 60;
        totalWorking = 0;
        statusWork = @"Working";
        pomodoro = 0;
        isWorking = true;

        enableLongBreak = (int)[_shareUserDefaults integerForKey:@"key_switchonoff_longbreak"];
        
        _pauseBtn.hidden = YES;
        _stopBtn.hidden = YES;
        _startBtn.hidden = NO;
        
        _labelStatusWorking.text = @"";
        [self updateLabel];
    }
    
    NSString *stringKeyTimerRunning;
    stringKeyTimerRunning = [_shareUserDefaults stringForKey:@"key_timer_running"];
    
    if ([stringKeyTimerRunning isEqualToString:@"start_containing_app"]) {
        
        [timer invalidate];
        timer = nil;
        [_shareUserDefaults setObject:@"" forKey:@"key_timer_running"];
        timeMinutes = (int) [_shareUserDefaults integerForKey:@"key_time_minutes"];
        timeSeconds = (int) [_shareUserDefaults integerForKey:@"key_time_seconds"];
        [self updateLabel];
        totalTime = (int)[_shareUserDefaults integerForKey:@"key_total_time"];
        [_pauseBtn setTitle:@"Pasue" forState:UIControlStateNormal];
        
        _pauseBtn.hidden = NO;
        _stopBtn.hidden = NO;
        _startBtn.hidden = YES;
        
        totalWorking = (int)[_shareUserDefaults integerForKey:@"key_total_work"];
        pomodoro = (int) [_shareUserDefaults integerForKey:@"key_total_pomodoro"];
        statusWork = [_shareUserDefaults stringForKey:@"key_status_working"];
        
        _labelStatusWorking.text = statusWork;
        timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(runningTimer)
                                               userInfo:nil
                                                repeats:YES];
    } else if ([stringKeyTimerRunning isEqualToString:@"pause_containing_app"]) {
        
        [_shareUserDefaults setObject:@"" forKey:@"key_timer_running"];
        [timer invalidate];
        timeMinutes = (int) [_shareUserDefaults integerForKey:@"key_time_minutes"];
        timeSeconds = (int) [_shareUserDefaults integerForKey:@"key_time_seconds"];
        [self updateLabel];
        totalTime = timeMinutes * 60 + timeSeconds + 1;
        [_pauseBtn setTitle:@"Start" forState:UIControlStateNormal];
        _startBtn.hidden = YES;
        _pauseBtn.hidden = NO;
        _stopBtn.hidden = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.preferredContentSize = CGSizeMake(screenSize.width, 100);
//    isRunning = (BOOL)[_shareUserDefaults boolForKey:@"key_check_timer_started"];
//    if (isRunning == false) {
        _pauseBtn.hidden = YES;
        _stopBtn.hidden = YES;
        
        _shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
        timeWork = (int) [_shareUserDefaults integerForKey:@"key_time_work"];
        timeBreak = (int) [_shareUserDefaults integerForKey:@"key_time_break"];
        timeLongBreak = (int) [_shareUserDefaults integerForKey:@"key_time_longbreak"];
        frequency = (int) [_shareUserDefaults integerForKey:@"key_frequency"];
        timeMinutes = timeWork;
        timeSeconds = 0;
        totalTime = timeWork * 60;
        enableLongBreak = (int)[_shareUserDefaults integerForKey:@"key_switchonoff_longbreak"];
    
    _labelStatusWorking.text = @"";
        [self updateLabel];
    //}
}
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    
    completionHandler(NCUpdateResultNewData);
}

- (IBAction)StartOnClicked:(id)sender {
    
    NSLog(@"minutes : %ld", (long)[_shareUserDefaults integerForKey:@"key_time_work"]);
    NSLog(@"seconds : %ld", (long)[_shareUserDefaults integerForKey:@"key_time_break"]);
    
    
    [_shareUserDefaults setInteger:totalTime - 1 forKey:@"key_total_time"];
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(runningTimer)
                                           userInfo:nil
                                            repeats:YES];
    statusWork = @"Working";
    totalWorking = 0;
    pomodoro = 0;
    isWorking = true;
    isRunning = true;
    _labelStatusWorking.text = statusWork;
    [_shareUserDefaults setBool:isRunning forKey:@"key_check_timer_statred"];
    [_shareUserDefaults setObject:statusWork forKey:@"key_status_working"];
    [_shareUserDefaults setBool:isWorking forKey:@"key_is_working"];
    [_shareUserDefaults setInteger:pomodoro forKey:@"key_total_pomodoro"];
    [_shareUserDefaults setObject:@"running" forKey:@"key_timer_running"];
    [_shareUserDefaults setInteger:0 forKey:@"key_total_work"];
    [_shareUserDefaults setInteger:timeMinutes forKey:@"key_time_minutes"];
    [_shareUserDefaults setInteger:timeSeconds forKey:@"key_time_seconds"];
    _pauseBtn.hidden = NO;
    _stopBtn.hidden = NO;
    _startBtn.hidden = YES;
    
    NSURL *url = [NSURL URLWithString:@"pomodoro://"];
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        
    }];
    
}

- (void) runningTimer {
    totalTime --;
    timeMinutes = totalTime / 60;
    timeSeconds = totalTime - timeMinutes * 60;
    [_shareUserDefaults setInteger:totalTime forKey:@"key_total_time"];
    [_shareUserDefaults setInteger:timeMinutes forKey:@"key_time_minutes"];
    [_shareUserDefaults setInteger:timeSeconds forKey:@"key_time_seconds"];
    
    if (totalTime == 0) {
        if ([statusWork isEqual:@"Working"]) {
            isWorking = false;
            totalWorking ++;
            [_shareUserDefaults setBool:isWorking forKey:@"key_is_working"];
            [_shareUserDefaults setInteger:totalWorking forKey:@"key_total_work"];
            if (enableLongBreak == 0) {
                timeMinutes = timeBreak;
                timeSeconds = 0;
                //[self updateLabel];
                totalTime = timeBreak * 60;
                statusWork = @"Breaking";
                _labelStatusWorking.text = statusWork;
                [_shareUserDefaults setObject:statusWork forKey:@"key_status_working"];
            } else if (enableLongBreak == 1){
                if (totalWorking > 0 && totalWorking % frequency == 0) {
//                    pomodoro ++;
//                    [_shareUserDefaults setInteger:pomodoro forKey:@"key_total_pomodoro"];
                    
                    timeMinutes = timeLongBreak;
                    timeSeconds = 0;
                    //[self updateLabel];
                    totalTime = timeLongBreak * 60;
                    statusWork = @"Long Breaking";
                    _labelStatusWorking.text = statusWork;
                    [_shareUserDefaults setObject:statusWork forKey:@"key_status_working"];
                } else {
                    
                    timeMinutes = timeBreak;
                    timeSeconds = 0;
                    //[self updateLabel];
                    totalTime = timeBreak * 60;
                    statusWork = @"Breaking";
                    _labelStatusWorking.text = statusWork;
                    [_shareUserDefaults setObject:@"Breaking" forKey:@"key_status_working"];
                }
            }
        } else if ([statusWork isEqualToString:@"Breaking"] || [statusWork isEqualToString:@"Long Breaking"]) {
            
            timeMinutes = timeWork;
            timeSeconds = 0;
            //[self updateLabel];
            isWorking = true;
            statusWork = @"Working";
            _labelStatusWorking.text = statusWork;
            totalTime = timeWork * 60;
            if (totalWorking > 0 && totalWorking % frequency == 0) {
                pomodoro ++;
                [_shareUserDefaults setInteger:pomodoro forKey:@"key_total_pomodoro"];
            }
            [_shareUserDefaults setBool:isWorking forKey:@"key_is_working"];
            [_shareUserDefaults setObject:statusWork forKey:@"key_status_working"];
        }
    }
    NSString *stringMinutes;
    NSString *stringSeconds;
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
- (IBAction)pauseOnClicked:(id)sender {
    if ([timer isValid]) {
        [timer invalidate];
        [_pauseBtn setTitle:@"Start" forState:UIControlStateNormal];
        [_shareUserDefaults setObject:@"pause" forKey:@"key_timer_running"];
        [_shareUserDefaults setInteger:totalTime forKey:@"key_total_time"];
        [_shareUserDefaults setInteger:timeMinutes forKey:@"key_time_minutes"];
        [_shareUserDefaults setInteger:timeSeconds forKey:@"key_time_seconds"];
        
        NSURL *url = [NSURL URLWithString:@"pomodoro://"];
        [self.extensionContext openURL:url completionHandler:^(BOOL success) {}];

    } else {
        [_pauseBtn setTitle:@"Pause" forState:UIControlStateNormal];
        _pauseBtn.titleLabel.font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:18];
        timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(runningTimer)
                                               userInfo:nil
                                                repeats:YES];
        [_shareUserDefaults setObject:@"start" forKey:@"key_timer_running"];
        NSURL *url = [NSURL URLWithString:@"pomodoro://"];
        [self.extensionContext openURL:url completionHandler:^(BOOL success) {}];
    }
}
- (IBAction)stopBtn:(id)sender {
    
    
    [timer invalidate];
    totalTime = timeWork * 60;
    timeMinutes = timeWork;
    timeSeconds = 0;
    
    totalWorking = 0;
    statusWork = @"Working";
    pomodoro = 0;
    isWorking = true;
    
    [_shareUserDefaults setInteger:pomodoro forKey:@"key_total_pomodoro"];
    [_shareUserDefaults setBool:isWorking forKey:@"key_is_working"];
    [_shareUserDefaults setInteger:0 forKey:@"key_total_work"];
    [_shareUserDefaults setObject:@"stop" forKey:@"key_timer_running"];
    [self updateLabel];
    
    _pauseBtn.hidden = YES;
    _stopBtn.hidden = YES;
    _startBtn.hidden = NO;
    
    _labelStatusWorking.text = @"";
    NSURL *url = [NSURL URLWithString:@"pomodoro://"];
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {}];
}

- (void) updateLabel {
    
    NSString *stringMinutes;
    NSString *stringSeconds;
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
//- (UIEdgeInsets) widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
//    defaultMarginInsets.bottom = 20.0;
//    return defaultMarginInsets;
//}

@end
