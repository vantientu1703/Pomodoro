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

@interface TimerViewController ()

@property (nonatomic, strong) SettingItem *settingItem;
@property (nonatomic, strong) TimerNotificationcenterItem *timerNotificationCenterItem;
@end

@implementation TimerViewController
{
    NSTimer *autoScrollTimer;
    int minutes;
    int seconds;
    BOOL isStartting;
    BOOL isWorking;
    int totalWorking;
    int totalBreaking;
    int totalLongBreaking;
    BOOL isActive;
    BOOL isChanged;
    int frequency;
    int switchOnOffLongBreak;
    AppDelegate *appDelegate;
    NSUserDefaults *userDefaults;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    _settingItem = appDelegate.settingItem;
    _timerNotificationCenterItem = appDelegate.timerNotificationcenterItem;
//    _settingItem.indexPathForCell = -1;
    [userDefaults setInteger:-1 forKey:keyIndexPathRow];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLabelMinutesAndSeconds:)
                                                 name:keyStartTimer
                                               object:nil];
    
    isActive = _settingItem.isActive;
    
    if (isActive && _timerNotificationCenterItem.isRunTimer) { // nếu timer = nil thì bắt đầu chạy timer
        [self updateLabelMinutesTextAndLabelSecondsTextWhenTimerRun:_timerNotificationCenterItem.timeMinutes and: _timerNotificationCenterItem.timeSeconds];
        _labelTask.text = _timerNotificationCenterItem.stringTaskname;
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
    }
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:0 forKey:keyIsChanged];
    [userDefaults setInteger:0 forKey:keyisActive];
    _settingItem.isChanged = 0;
    _settingItem.isActive = 0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

#pragma mark setup view
- (void) setupView {
    //_labelTotalWorking.adjustsFontSizeToFitWidth = YES;
    _labelTask.text = @"";
    _labelStatusWorking.text = @"";
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
    
    int minute = _settingItem.timeWork;
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
    _timerNotificationCenterItem.totalTime = _settingItem.timeWork * 60;
    [self setTextForLabelWhenSettingWasChanged];

}

- (IBAction)buttonStartOnClicked:(id)sender {
    if ([_timerNotificationCenterItem.timer isValid]) {
        _timerNotificationCenterItem.isRunTimer = false;
        [self setTextForLabelWhenSettingWasChanged];
        [appDelegate startStopTimer];
        [self updateLabelMinutesTextAndLabelSecondsTextWhenTimerRun:_timerNotificationCenterItem.timeMinutes and:_timerNotificationCenterItem.timeSeconds];
        
    } else {
        _timerNotificationCenterItem.isRunTimer = true;
        [_buttonStart setTitle:@"Pause" forState:UIControlStateNormal];
        [appDelegate startStopTimer];
        [self updateLabelMinutesTextAndLabelSecondsTextWhenTimerRun:_timerNotificationCenterItem.timeMinutes and:_timerNotificationCenterItem.timeSeconds];
    }
    
}


#pragma mark - auto scroll text 

- (void) autoScrollText {
    
}







@end
