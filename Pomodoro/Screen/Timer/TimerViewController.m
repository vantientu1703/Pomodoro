//
//  TimerViewController.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/13/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "TimerViewController.h"
#import "SettingItem.h"
#import "AppDelegate.h"
#import "SettingTimerViewController.h"


@interface TimerViewController ()

@property (nonatomic, strong) SettingItem *settingItem;
@property (nonatomic, strong) TimerNotificationcenterItem *timerNotificationCenterItem;
@end

@implementation TimerViewController
{
    NSTimer *autoScrollTimer;
    int minutes;
    int seconds;
    int totalWorking;
    int totalBreaking;
    int totalLongBreaking;
    int frequency;
    int switchOnOffLongBreak;
    int totalTime;
    
    BOOL isActive;
    BOOL isChanged;
    BOOL isStartting;
    BOOL isWorking;

    AppDelegate *appDelegate;
    NSUserDefaults *userDefaults;
    
    NSString *stringCheckTimerRunning;
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    _settingItem = appDelegate.settingItem;
    _timerNotificationCenterItem = appDelegate.timerNotificationcenterItem;
    
    userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
    [userDefaults setInteger:-1 forKey:KEY_INDEXPATH_ROW];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLabelMinutesAndSeconds:)
                                                 name:KEY_START_TIMER
                                               object:nil];
    
    isActive = _settingItem.isActive;
    
    if (isActive && _timerNotificationCenterItem.isRunTimer) { // nếu timer = nil thì bắt đầu chạy timer
        [self updateLabelMinutesTextAndLabelSecondsTextWhenTimerRun:_timerNotificationCenterItem.timeMinutes and: _timerNotificationCenterItem.timeSeconds];
        _labelTask.text = _timerNotificationCenterItem.stringTaskname;
        _taskTextView.text = _timerNotificationCenterItem.stringTaskname;
        [appDelegate startStopTimer];
        [self updateLabelTotalWorkingAndBreaking:_timerNotificationCenterItem.totalWorking andLongBreaking:_timerNotificationCenterItem.totalLongBreaking];
        
    } else if (!isActive && !_timerNotificationCenterItem.isRunTimer) { // nếu timer đang tạm ngừng thì tiếp tục chạy timer
        
        [appDelegate startStopTimer];
        [self updateLabelMinutesTextAndLabelSecondsTextWhenTimerRun:_timerNotificationCenterItem.timeMinutes and:_timerNotificationCenterItem.timeSeconds];
        [self updateLabelTotalWorkingAndBreaking:_timerNotificationCenterItem.totalWorking andLongBreaking:_timerNotificationCenterItem.totalLongBreaking];
    }
    if (_timerNotificationCenterItem.isRunTimer) { // cập nhật tiêu đề cho button phù hợp với trạng thái timer đang chạy hay đang dừng
        [_buttonStart setTitle:@"Pause" forState:UIControlStateNormal];
    } else {
        [_buttonStart setTitle:@"Start" forState:UIControlStateNormal];
    }
    
    
    isChanged = _settingItem.isChanged;
    if (isChanged == 1) {
        
        _timerNotificationCenterItem.totalTime = _settingItem.timeWork * 60;
        _timerNotificationCenterItem.timeSeconds = 0;
        [_timerNotificationCenterItem.timer invalidate];
        [self setTextForLabelWhenSettingWasChanged];
    } else {
        
        stringCheckTimerRunning = [userDefaults stringForKey:@"key_timer_running"];
        totalTime = (int)[userDefaults integerForKey:@"key_total_time"];
        if ([stringCheckTimerRunning isEqualToString:@"running"]) {
            
            [userDefaults setObject:@"" forKey:@"key_timer_running"];
//            _timerNotificationCenterItem.isRunTimer = false; // stop timer
//            [appDelegate startStopTimer];
            [_timerNotificationCenterItem.timer invalidate];
            _timerNotificationCenterItem.timer = nil;
            _timerNotificationCenterItem.isRunTimer = true; // run timer
            _timerNotificationCenterItem.isWorking = [userDefaults boolForKey:@"key_is_working"];
            _timerNotificationCenterItem.totalTime = totalTime;
            _timerNotificationCenterItem.totalWorking = (int)[userDefaults integerForKey:@"key_total_work"];
            _timerNotificationCenterItem.totalLongBreaking = (int) [userDefaults integerForKey:@"key_total_pomodoro"];
            _timerNotificationCenterItem.stringStatusWorking = [userDefaults stringForKey:@"key_status_working"];
            
            DebugLog(@"totaolWork: %d ____________", (int) [userDefaults integerForKey:@"key_total_work"]);
            [appDelegate startStopTimer];
            [_buttonStart setTitle:@"Pause" forState:UIControlStateNormal];
        } else if ([stringCheckTimerRunning isEqualToString:@"pause"]) {
            
            [userDefaults setObject:@"" forKey:@"key_timer_running"];
            _timerNotificationCenterItem.isRunTimer = false;
            [appDelegate startStopTimer];
            [self updateLabelMinutesTextAndLabelSecondsTextWhenTimerRun:(int)[userDefaults integerForKey:@"key_time_minutes"] and:(int)[userDefaults integerForKey:@"key_time_seconds"]];
            _timerNotificationCenterItem.timeMinutes = (int)[userDefaults integerForKey:@"key_time_minutes"];
            _timerNotificationCenterItem.timeSeconds = (int)[userDefaults integerForKey:@"key_time_seconds"];
            _timerNotificationCenterItem.totalTime = _timerNotificationCenterItem.timeMinutes * 60 + _timerNotificationCenterItem.timeSeconds;
            [_buttonStart setTitle:@"Start" forState:UIControlStateNormal];
            [_labelStatusWorking setText:[userDefaults stringForKey:@"key_status_working"]];
        } else if ([stringCheckTimerRunning isEqualToString:@"start"]) {
            
            [_timerNotificationCenterItem.timer invalidate];
            _timerNotificationCenterItem.timer = nil;
            _timerNotificationCenterItem.isRunTimer = true;
            _timerNotificationCenterItem.totalTime = totalTime;
            [appDelegate startStopTimer];
            [_buttonStart setTitle:@"Pause" forState:UIControlStateNormal];
        } else if ([stringCheckTimerRunning isEqualToString:@"stop"]) {
            [userDefaults setObject:@"" forKey:@"key_timer_running"];
            
            _timerNotificationCenterItem.isRunTimer = false;
            [_timerNotificationCenterItem.timer invalidate];
            _timerNotificationCenterItem.timer = nil;
            _timerNotificationCenterItem.isWorking = true;
            _timerNotificationCenterItem.timeMinutes = _settingItem.timeWork;
            _timerNotificationCenterItem.timeSeconds = 0;
            _timerNotificationCenterItem.totalLongBreaking = 0;
            _timerNotificationCenterItem.totalWorking = 0;
            _timerNotificationCenterItem.totalTime = _settingItem.timeWork * 60;
            [self setTextForLabelWhenSettingWasChanged];
        }
    }
    
    [userDefaults setInteger:0 forKey:KEY_IS_CHANGED];
    _settingItem.isChanged = 0;
    [userDefaults setInteger:0 forKey:KEY_IS_ACTIVE];
    _settingItem.isActive = 0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushTabbarViewControllerIndex2) name:@"appDidBecomeActive"
                                               object:nil];
}
- (void) pushTabbarViewControllerIndex2 {
    if (isChanged == 1) {
        _timerNotificationCenterItem.totalTime = _settingItem.timeWork * 60;
        _timerNotificationCenterItem.timeSeconds = 0;
        [_timerNotificationCenterItem.timer invalidate];
        [self setTextForLabelWhenSettingWasChanged];
    } else {
        stringCheckTimerRunning = [userDefaults stringForKey:@"key_timer_running"];
        totalTime = (int)[userDefaults integerForKey:@"key_total_time"];
        if ([stringCheckTimerRunning isEqualToString:@"running"]) {
            
            [userDefaults setObject:@"" forKey:@"key_timer_running"];
            [_timerNotificationCenterItem.timer invalidate];
            _timerNotificationCenterItem.timer = nil;
            _timerNotificationCenterItem.isRunTimer = true; // run timer
            _timerNotificationCenterItem.isWorking = [userDefaults boolForKey:@"key_is_working"];
            _timerNotificationCenterItem.timeMinutes = (int)[userDefaults integerForKey:@"key_time_minutes"];
            _timerNotificationCenterItem.timeSeconds = (int)[userDefaults integerForKey:@"key_time_seconds"];
            _timerNotificationCenterItem.totalTime = totalTime;
            _timerNotificationCenterItem.totalWorking = (int)[userDefaults integerForKey:@"key_total_work"];
            _timerNotificationCenterItem.totalLongBreaking = (int) [userDefaults integerForKey:@"key_total_pomodoro"];
            _timerNotificationCenterItem.stringStatusWorking = [userDefaults stringForKey:@"key_status_working"];
            
            DebugLog(@"totaolWork: %d ____________", (int) [userDefaults integerForKey:@"key_total_work"]);
            [appDelegate startStopTimer];
            [_buttonStart setTitle:@"Pause" forState:UIControlStateNormal];
        } else if ([stringCheckTimerRunning isEqualToString:@"pause"]) {
            
            [userDefaults setObject:@"" forKey:@"key_timer_running"];
            _timerNotificationCenterItem.isRunTimer = false;
            [appDelegate startStopTimer];
            [self updateLabelMinutesTextAndLabelSecondsTextWhenTimerRun:(int)[userDefaults integerForKey:@"key_time_minutes"] and:(int)[userDefaults integerForKey:@"key_time_seconds"]];
            _timerNotificationCenterItem.timeMinutes = (int)[userDefaults integerForKey:@"key_time_minutes"];
            _timerNotificationCenterItem.timeSeconds = (int)[userDefaults integerForKey:@"key_time_seconds"];
            _timerNotificationCenterItem.totalTime = _timerNotificationCenterItem.timeMinutes * 60 + _timerNotificationCenterItem.timeSeconds;
            [_buttonStart setTitle:@"Start" forState:UIControlStateNormal];
            [_labelStatusWorking setText:[userDefaults stringForKey:@"key_status_working"]];
        } else if ([stringCheckTimerRunning isEqualToString:@"start"]) {
            
            [_timerNotificationCenterItem.timer invalidate];
            _timerNotificationCenterItem.timer = nil;
            _timerNotificationCenterItem.isRunTimer = true;
            _timerNotificationCenterItem.totalTime = totalTime;
            [appDelegate startStopTimer];
            [_buttonStart setTitle:@"Pause" forState:UIControlStateNormal];
        } else if ([stringCheckTimerRunning isEqualToString:@"stop"]) {
            [userDefaults setObject:@"" forKey:@"key_timer_running"];
            
            _timerNotificationCenterItem.isRunTimer = false;
            [_timerNotificationCenterItem.timer invalidate];
            _timerNotificationCenterItem.timer = nil;
            _timerNotificationCenterItem.isWorking = true;
            _timerNotificationCenterItem.timeMinutes = _settingItem.timeWork;
            _timerNotificationCenterItem.timeSeconds = 0;
            _timerNotificationCenterItem.totalLongBreaking = 0;
            _timerNotificationCenterItem.totalWorking = 0;
            _timerNotificationCenterItem.totalTime = _settingItem.timeWork * 60;
            [self setTextForLabelWhenSettingWasChanged];
        }
    }
    
    [userDefaults setInteger:0 forKey:KEY_IS_CHANGED];
    _settingItem.isChanged = 0;

}
#pragma mark setup view
- (void) setupView {
    //_labelTotalWorking.adjustsFontSizeToFitWidth = YES;
    _labelTask.text = @"";
    //[_labelTask setFont:[UIFont fontWithName:@"Thin" size:17]];
    //_taskTextView.text = @"";
    _taskTextView.editable = NO;
    _labelStatusWorking.text = @"";
    _buttonStart.layer.cornerRadius = _buttonStart.frame.size.width / 2;
    _buttonStart.layer.borderWidth = 2;
    _buttonStart.layer.borderColor = [UIColor blueColor].CGColor;
}

- (void) updateLabelMinutesAndSeconds: (NSNotification *) notification { //hàm này đc chạy liên tục khi timer đang chạy để cập nhật liên tục thời gian và label work và break
    [self updateLabelMinutesTextAndLabelSecondsTextWhenTimerRun:_timerNotificationCenterItem.timeMinutes and:_timerNotificationCenterItem.timeSeconds];
    _labelStatusWorking.text = _timerNotificationCenterItem.stringStatusWorking;
    [self updateLabelTotalWorkingAndBreaking:_timerNotificationCenterItem.totalWorking andLongBreaking:_timerNotificationCenterItem.totalLongBreaking];
}

- (void) updateLabelMinutesTextAndLabelSecondsTextWhenTimerRun: (int) minute and: (int) second { //  cap nhat label minutes va seconds
    
    if (minute >= 10) {
        _labelMinute.text = [NSString stringWithFormat:@"%d",minute];
    } else {
        _labelMinute.text = [NSString stringWithFormat:@"0%d",minute];
    }
    if (second >= 10) {
        _labelSecond.text = [NSString stringWithFormat:@"%d", second];
    } else {
        _labelSecond.text = [NSString stringWithFormat:@"0%d", second];
    }
    if (second == 0 && minute == 0) { // để hiển thị đúng thứ tự thời gian khi timer bắt đầu lại với giá trị minutes mới. có thể đc hiểu như sau: khi thời gian đếm lùi về 00 : 00 thì minutes (thời gian bắt đầu chạy timer) sẽ hiển thị minutes : 00 rồi mới đếm lùi về (minutes - 1) : 59 --
        if (_timerNotificationCenterItem.isWorking) {
             minute = _settingItem.timeWork;
        } else {
           
            if (_timerNotificationCenterItem.totalWorking > 0 && _timerNotificationCenterItem.totalWorking % _settingItem.frequency == 0 && _settingItem.switchOnOffLongBreak == true) {
                minute = _settingItem.timeLongBreak;
            } else {
                minute = _settingItem.timeBreak;
            }
        }
        if (minute >= 10) {
            _labelMinute.text = [NSString stringWithFormat:@"%d",minute];
        } else {
            _labelMinute.text = [NSString stringWithFormat:@"0%d",minute];
        }
    }
}
- (void) setTextForLabelWhenSettingWasChanged {
    
    int minute = _settingItem.timeWork;//Users/vantientu/Desktop/Pomodoro/Pomodoro/Screen/Timer/TimerViewController.m
    if (minute >= 10) {
        _labelMinute.text = [NSString stringWithFormat:@"%d",minute];
    } else {
        _labelMinute.text = [NSString stringWithFormat:@"0%d",minute];
    }
    _labelSecond.text = [NSString stringWithFormat:@"00"];
    [self updateLabelTotalWorkingAndBreaking:_timerNotificationCenterItem.totalWorking andLongBreaking:_timerNotificationCenterItem.totalLongBreaking];
    [_labelStatusWorking setText:@""];
    [_buttonStart setTitle:@"Start" forState:UIControlStateNormal];
}
- (void) updateLabelTotalWorkingAndBreaking: (int) itotalWorking andLongBreaking: (int) itotalLongBreaking {
    [_labelTotalLongBreaking setText:[NSString stringWithFormat:@"Pomodoros : %d", itotalLongBreaking]];
}
#pragma mark button Start


- (IBAction)stopOnClicked:(id)sender {
    
    _timerNotificationCenterItem.isRunTimer = false;
    [_timerNotificationCenterItem.timer invalidate];
    _timerNotificationCenterItem.timer = nil;
    _timerNotificationCenterItem.isWorking = true;
    _timerNotificationCenterItem.timeMinutes = _settingItem.timeWork;
    _timerNotificationCenterItem.timeSeconds = 0;
    _timerNotificationCenterItem.totalLongBreaking = 0;
    _timerNotificationCenterItem.totalWorking = 0;
    _timerNotificationCenterItem.totalTime = _settingItem.timeWork * 60;
    _timerNotificationCenterItem.stringStatusWorking = @"Working";
    [self setTextForLabelWhenSettingWasChanged];

    [userDefaults setObject:@"stop_containing_app" forKey:@"key_timer_running"];
}

- (IBAction)buttonStartOnClicked:(id)sender {
    if ([_timerNotificationCenterItem.timer isValid]) {
        _timerNotificationCenterItem.isRunTimer = false;
        //[self setTextForLabelWhenSettingWasChanged];
        [appDelegate startStopTimer];
        [self updateLabelMinutesTextAndLabelSecondsTextWhenTimerRun:_timerNotificationCenterItem.timeMinutes and:_timerNotificationCenterItem.timeSeconds];
        _labelStatusWorking.text = _timerNotificationCenterItem.stringStatusWorking;
        [_buttonStart setTitle:@"Start" forState:UIControlStateNormal];
        [userDefaults setObject:@"pause_containing_app" forKey:@"key_timer_running"];
        //[userDefaults setInteger:_timerNotificationCenterItem.totalTime forKey:@"key_total_time"];
        [userDefaults setInteger:_timerNotificationCenterItem.timeMinutes forKey:@"key_time_minutes"];
        [userDefaults setInteger:_timerNotificationCenterItem.timeSeconds forKey:@"key_time_seconds"];
        
        
        DebugLog(@"total Time :__________ %d", _timerNotificationCenterItem.totalTime);
    } else {
        _timerNotificationCenterItem.isRunTimer = true;
        [_buttonStart setTitle:@"Pause" forState:UIControlStateNormal];
        [appDelegate startStopTimer];
        [self updateLabelMinutesTextAndLabelSecondsTextWhenTimerRun:_timerNotificationCenterItem.timeMinutes and:_timerNotificationCenterItem.timeSeconds];
        [userDefaults setObject:@"start_containing_app" forKey:@"key_timer_running"];
        //[userDefaults setInteger:_timerNotificationCenterItem.totalTime forKey:@"key_total_time"];
        [userDefaults setInteger:_timerNotificationCenterItem.timeMinutes forKey:@"key_time_minutes"];
        [userDefaults setInteger:_timerNotificationCenterItem.timeSeconds forKey:@"key_time_seconds"];
        [userDefaults setInteger:_timerNotificationCenterItem.totalLongBreaking forKey:@"key_total_pomodoro"];
        [userDefaults setInteger:_timerNotificationCenterItem.totalWorking forKey:@"key_total_work"];
        if (_timerNotificationCenterItem.timer == nil) {
            [userDefaults setObject:@"Working" forKey:@"key_status_working"];
        } else {
            [userDefaults setObject:_timerNotificationCenterItem.stringStatusWorking forKey:@"key_status_working"];
        }
    }
}

#pragma mark - auto scroll text

- (void) autoScrollText {
    
}







@end
