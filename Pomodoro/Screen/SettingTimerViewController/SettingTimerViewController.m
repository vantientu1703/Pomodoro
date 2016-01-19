//
//  SettingTimerViewController.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/13/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "SettingTimerViewController.h"
#import "AppDelegate.h"
#import "SettingItem.h"

@interface SettingTimerViewController ()

@property (nonatomic, strong) SettingItem *settingItem;
@property (nonatomic, strong) TimerNotificationcenterItem *timerNotificationCenterItem;
@end

@implementation SettingTimerViewController
{
    int _timerWork;
    int _timeBreak;
    int _timeLongBreak;
    int _frequency;
    int _switchOnOffLongBreak;
    NSUserDefaults *userDefaults;
    AppDelegate *appDelegate;
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem = nil;
        
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.settingItem = appDelegate.settingItem;
    userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
    
    [userDefaults setInteger:0 forKey:KEY_IS_CHANGED];
    _settingItem.isChanged = 0;
    
    _timerWork = _settingItem.timeWork;
    _timeBreak = _settingItem.timeBreak;
    _timeLongBreak = _settingItem.timeLongBreak;
    _frequency = _settingItem.frequency;
    _switchOnOffLongBreak = _settingItem.switchOnOffLongBreak;
    
    _labelTimerWork.text = [NSString stringWithFormat:@"%d minutes",_timerWork];
    _labelTimerBreak.text = [NSString stringWithFormat:@"%d minutes",_timeBreak];
    _labelTimerLongBreak.text = [NSString stringWithFormat:@"%d minutes",_timeLongBreak];
    _labelFrequency.text = [NSString stringWithFormat:@"Every %d",_frequency];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    self.settingItem = appDelegate.settingItem;
    _timerNotificationCenterItem = appDelegate.timerNotificationcenterItem;
    userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
    
    DebugLog(@"TimeWork: __%d", _settingItem.timeWork);
    DebugLog(@"TimeBreak: __%d", _settingItem.timeBreak);
    DebugLog(@"TimeLongBreak: __%d", _settingItem.timeLongBreak);
    DebugLog(@"Frequency: __%d", _settingItem.frequency);
    DebugLog(@"Enable Longbreak: %d", _settingItem.switchOnOffLongBreak);
    
    _changeTimerWork.selectedSegmentIndex = -1;
    _changeTimerBreak.selectedSegmentIndex = -1;
    _changeTimerLongBreak.selectedSegmentIndex = -1;
    _changeFrequency.selectedSegmentIndex = -1;
    
    _timerWork = _settingItem.timeWork;
    _timeBreak = _settingItem.timeBreak;
    _timeLongBreak = _settingItem.timeLongBreak;
    _frequency = _settingItem.frequency;
    _switchOnOffLongBreak = _settingItem.switchOnOffLongBreak;
    
    _labelTimerWork.text = [NSString stringWithFormat:@"%d minutes",_timerWork];
    _labelTimerBreak.text = [NSString stringWithFormat:@"%d minutes",_timeBreak];
    _labelTimerLongBreak.text = [NSString stringWithFormat:@"%d minutes",_timeLongBreak];
    _labelFrequency.text = [NSString stringWithFormat:@"Every %d",_frequency];
    
    if (_switchOnOffLongBreak == 1) {
        _switchLongBreak.on = YES;
        _changeTimerLongBreak.enabled = YES;
        _changeFrequency.enabled = YES;
    } else {
        _switchLongBreak.on = NO;
        _changeTimerLongBreak.enabled = NO;
        _changeFrequency.enabled = NO;
    }
    if (_settingItem.isSound) {
        _enableSound.on = YES;
    }else {
        _enableSound.on = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushTabbarViewControllerIndex2) name:@"appDidBecomeActive"
                                               object:nil];
}

- (void) pushTabbarViewControllerIndex2 {
    self.tabBarController.selectedIndex = 1;
}
#pragma mark - setting timer

- (IBAction)changeTimeWork:(id)sender {
    
    switch (_changeTimerWork.selectedSegmentIndex) {
        case 0:
        {
            _timerWork --;
            if (_timerWork >=1) {
                _labelTimerWork.text = [NSString stringWithFormat:@"%d minutes",_timerWork];
            } else {
                _timerWork = 1;
            }
            _changeTimerWork.selectedSegmentIndex = -1;
            
            [self createRightButtonItem];
        }
            break;
        case 1:
        {
            _timerWork ++;
            if (_timerWork > 90) {
                _timerWork = 90;
            }
            _labelTimerWork.text = [NSString stringWithFormat:@"%d minutes",_timerWork];
            _changeTimerWork.selectedSegmentIndex = -1;
            
            [self createRightButtonItem];
        }
        default:
            break;
    }
}

- (IBAction)changeTimeBreak:(id)sender {
    switch (_changeTimerBreak.selectedSegmentIndex) {
        case 0:
        {
            _timeBreak --;
            if (_timeBreak >= 1) {
                _labelTimerBreak.text = [NSString stringWithFormat:@"%d minutes",_timeBreak];
            } else {
                _timeBreak = 1;
            }
            _changeTimerBreak.selectedSegmentIndex = -1;
            [self createRightButtonItem];
        }
            break;
        case 1:
        {
            _timeBreak ++;
            if (_timeBreak > 90) {
                _timeBreak = 90;
            }
            _labelTimerBreak.text = [NSString stringWithFormat:@"%d minutes",_timeBreak];

            _changeTimerBreak.selectedSegmentIndex = -1;
            [self createRightButtonItem];
        }
        default:
            break;
    }
}

- (IBAction)changeTimeLongBreak:(id)sender {
    switch (_changeTimerLongBreak.selectedSegmentIndex) {
        case 0:
        {
            _timeLongBreak --;
            if (_timeLongBreak >= 1) {
                _labelTimerLongBreak.text = [NSString stringWithFormat:@"%d minutes",_timeLongBreak];
            } else {
                _timeLongBreak = 1;
            }
            _changeTimerLongBreak.selectedSegmentIndex = -1;
            [self createRightButtonItem];
        }
            break;
        case 1:
        {
            _timeLongBreak ++;
            if (_timeLongBreak > 90) {
                _timeLongBreak = 90;
            }
            _labelTimerLongBreak.text = [NSString stringWithFormat:@"%d minutes",_timeLongBreak];
            _changeTimerLongBreak.selectedSegmentIndex = -1;
            [self createRightButtonItem];
        }
        default:
            break;
    }
}

- (IBAction)changeFrequency:(id)sender {
    switch (_changeFrequency.selectedSegmentIndex) {
        case 0:
        {
            _frequency --;
            if (_frequency >= 2) {
                _labelFrequency.text = [NSString stringWithFormat:@"Every %d",_frequency];
            } else {
                _frequency = 2;
            }
            _changeFrequency.selectedSegmentIndex = -1;
            [self createRightButtonItem];
        }
            break;
        case 1:
        {
            _frequency ++;
            if (_frequency > 5) {
                _frequency = 5;
            }
            _labelFrequency.text = [NSString stringWithFormat:@"Every %d",_frequency];
            _changeFrequency.selectedSegmentIndex = -1;
            [self createRightButtonItem];
        }
            
        default:
            break;
    }
}

- (IBAction)switchLongBreak:(id)sender {
    
    if (_switchLongBreak.on == YES) {
        [userDefaults setInteger:1 forKey:KEY_SWITCH_ONOFF_LONG_BREAK];
        _settingItem.switchOnOffLongBreak = 1;
        _changeTimerLongBreak.enabled = YES;
        _changeFrequency.enabled = YES;
    } else {
        [userDefaults setInteger:0 forKey:KEY_SWITCH_ONOFF_LONG_BREAK];
        _settingItem.switchOnOffLongBreak = 0;
        _changeFrequency.enabled = NO;
        _changeTimerLongBreak.enabled = NO;
    }
    
    [self createRightButtonItem];
}

- (IBAction)EnableSound:(id)sender {
    
    if (_enableSound.on == YES) {
        [userDefaults setBool:true forKey:KEY_IS_SOUND];
        _settingItem.isSound = true;
    } else {
        [userDefaults setBool:false forKey:KEY_IS_SOUND];
        _settingItem.isSound = false;
    }
}


#pragma mark - UIBarButtonItem

- (void) createRightButtonItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(hiddenRightButtonItem)];
}

- (void) hiddenRightButtonItem {
    [userDefaults setInteger:_timerWork forKey:KEY_TIME_WORK];
    _settingItem.timeWork = _timerWork;
    
    [userDefaults setInteger:_timeBreak forKey:KEY_TIME_BREAK];
    _settingItem.timeBreak = _timeBreak;
    
    [userDefaults setInteger:_timeLongBreak forKey:KEY_TIME_LONG_BREAK];
    _settingItem.timeLongBreak = _timeLongBreak;

    [userDefaults setInteger:_frequency forKey:KEY_FREQUENCY];
    _settingItem.frequency = _frequency;
    
    if (_switchLongBreak.on == YES) {
        [userDefaults setInteger:1 forKey:KEY_SWITCH_ONOFF_LONG_BREAK];
        _settingItem.switchOnOffLongBreak = 1;
    } else {
        [userDefaults setInteger:0 forKey:KEY_SWITCH_ONOFF_LONG_BREAK];
        _settingItem.switchOnOffLongBreak = 0;
    }
    
    [userDefaults setInteger:1 forKey:KEY_IS_CHANGED];
    _settingItem.isChanged = 1;
    
    _timerNotificationCenterItem.isRunTimer = false;
    [_timerNotificationCenterItem.timer invalidate];
    _timerNotificationCenterItem.timer = nil;
    _timerNotificationCenterItem.timeMinutes = _timerWork;
    _timerNotificationCenterItem.totalWorking = 0;
    _timerNotificationCenterItem.totalLongBreaking = 0;
    
    [userDefaults setBool:true forKey:@"key_is_changed_from_containingapp"];
    [userDefaults setObject:@"" forKey:@"key_timer_running"];
    [userDefaults setBool:false forKey:@"key_is_check_timer_running"];
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationItem.rightBarButtonItem = nil;
}

@end
