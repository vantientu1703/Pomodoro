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
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setInteger:0 forKey:keyIsChanged];
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
    DebugLog(@"TimeWork: __%d", _settingItem.timeWork);
    DebugLog(@"TimeBreak: __%d", _settingItem.timeBreak);
    DebugLog(@"TimeLongBreak: __%d", _settingItem.timeLongBreak);
    DebugLog(@"Frequency: __%d", _settingItem.frequency);
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
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
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
        [userDefaults setInteger:1 forKey:keySwitchOnOffLongBreak];
        _settingItem.switchOnOffLongBreak = 1;
        _changeTimerLongBreak.enabled = YES;
        _changeFrequency.enabled = YES;
    } else {
        [userDefaults setInteger:0 forKey:keySwitchOnOffLongBreak];
        _settingItem.switchOnOffLongBreak = 0;
        _changeFrequency.enabled = NO;
        _changeTimerLongBreak.enabled = NO;
    }
    
    [self createRightButtonItem];
}

#pragma mark - UIBarButtonItem

- (void) createRightButtonItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(hiddenRightButtonItem)];
}

- (void) hiddenRightButtonItem {
    [userDefaults setInteger:_timerWork forKey:keyTimeWork];
    _settingItem.timeWork = _timerWork;
    
    [userDefaults setInteger:_timeBreak forKey:keyTimeBreak];
    _settingItem.timeBreak = _timeBreak;
    
    [userDefaults setInteger:_timeLongBreak forKey:keyTimeLongBreak];
    _settingItem.timeLongBreak = _timeLongBreak;

    [userDefaults setInteger:_frequency forKey:keyFrequency];
    _settingItem.frequency = _frequency;
    
    if (_switchLongBreak.on == YES) {
        [userDefaults setInteger:1 forKey:keySwitchOnOffLongBreak];
        _settingItem.switchOnOffLongBreak = 1;
    } else {
        [userDefaults setInteger:0 forKey:keySwitchOnOffLongBreak];
        _settingItem.switchOnOffLongBreak = 0;
    }
    
    [userDefaults setInteger:1 forKey:keyIsChanged];
    _settingItem.isChanged = 1;
    
    _timerNotificationCenterItem.isRunTimer = false;
    [_timerNotificationCenterItem.timer invalidate];
    _timerNotificationCenterItem.timer = nil;
    _timerNotificationCenterItem.timeMinutes = _timerWork;
    _timerNotificationCenterItem.totalWorking = 0;
    _timerNotificationCenterItem.totalLongBreaking = 0;
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationItem.rightBarButtonItem = nil;
}

@end
