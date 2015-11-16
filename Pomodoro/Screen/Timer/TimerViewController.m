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
@end

@implementation TimerViewController
{
    NSTimer *timer;
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
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    DebugLog(@"in gi ra di");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    appDelegate = [[UIApplication sharedApplication] delegate];
    _settingItem = appDelegate.settingItem;
    isActive = _settingItem.isActive;
    isChanged = _settingItem.isChanged;
    
    if (isChanged && !isActive && (timer == nil || ![timer isValid] || [timer isValid])) {
        [timer invalidate];
        minutes = _settingItem.timeWork - 1;
        seconds = 60;
        [self setupLabelMinutesText:minutes + 1];
        _labelSecond.text = @"00";
        [_buttonStart setTitle:@"Start" forState:UIControlStateNormal];
        
        switchOnOffLongBreak = _settingItem.switchOnOffLongBreak;
        isStartting = false;
    }
    if (isActive) {
        //appDelegate = [[UIApplication sharedApplication] delegate];
        //_settingItem = appDelegate.settingItem;
        [timer invalidate];
        
        minutes = _settingItem.timeWork - 1;
        seconds = 60;
        [self setupLabelMinutesText:minutes + 1];
        [_labelSecond setText:@"00"];
        [_buttonStart setTitle:@"Pause" forState:UIControlStateNormal];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLabelTimer) userInfo:nil repeats:YES];
        
        isStartting = true;
        isWorking = true;
        totalWorking = 0;
        totalBreaking = 0;
        totalLongBreaking = 0;
        frequency = _settingItem.frequency;
        switchOnOffLongBreak = _settingItem.switchOnOffLongBreak;
        
        
        _labelTotalWorking.text = [NSString stringWithFormat:@"Number Of Time Working : %d", totalWorking];
        _labelTotalBreaking.text = [NSString stringWithFormat:@"Number Of Time Breaking : %d", totalBreaking];
        _labelTotalLongBreaking.text = [NSString stringWithFormat:@"Number Of Time Long Breaking : %d", totalLongBreaking];
    }
    [userDefaults setInteger:0 forKey:keyisActive];
    _settingItem.isActive = 0;
    [userDefaults setInteger:0 forKey:keyIsChanged];
    _settingItem.isChanged = 0;
    [self setupView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    if (isActive == false) {
        appDelegate = [[UIApplication sharedApplication] delegate];
        self.settingItem = appDelegate.settingItem;
        minutes = self.settingItem.timeWork - 1;
        seconds = 60;
        
        //isActive = self.settingItem.isActive;
        [self setupLabelMinutesText:minutes + 1];
        _labelSecond.text = @"00";
        
        [_buttonStart setTitle:@"Start" forState:UIControlStateNormal];
        
        isStartting = false;
    }

    isWorking = true;
    totalWorking = 0;
    totalBreaking = 0;
    totalLongBreaking = 0;
    frequency = _settingItem.frequency;
    switchOnOffLongBreak = _settingItem.switchOnOffLongBreak;
    DebugLog(@"switchOnOff: %d", switchOnOffLongBreak);
}

#pragma mark setup view

- (void) setupView {
    _labelTotalWorking.adjustsFontSizeToFitWidth = YES;
    _labelTotalBreaking.adjustsFontSizeToFitWidth = YES;
}
- (void) setupLabelMinutesText: (int) minute {
    
    if (minute >= 10) {
        _labelMinute.text = [NSString stringWithFormat:@"%d",minute];
        //_labelSecond.text = @"00";
    } else {
        _labelMinute.text = [NSString stringWithFormat:@"0%d",minute];
    }
}


#pragma mark button Start

- (IBAction)buttonStartOnClicked:(id)sender {
    if (isActive == true) {
        if (isStartting == false) {
            if (isStartting == true) {
                [_buttonStart setTitle:@"Start" forState:UIControlStateNormal];
                [timer invalidate];
                
                isStartting = false;
            } else if (isStartting == false){
                [_buttonStart setTitle:@"Pause" forState:UIControlStateNormal];
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLabelTimer) userInfo:nil repeats:YES];
                
                isStartting = true;
            }
        }
    } else if (isActive == false) {
        if (isStartting == false) {
            [_buttonStart setTitle:@"Pause" forState:UIControlStateNormal];
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLabelTimer) userInfo:nil repeats:YES];
            isStartting = true;
        } else {
            [_buttonStart setTitle:@"Start" forState:UIControlStateNormal];
            [timer invalidate];
            
            isStartting = false;
        }
    }
    
}

#pragma mark implement Timer

- (void) updateLabelTimer {
    
    seconds --;
    [self setupLabelMinutesText:minutes];
    
    if (seconds >= 10) {
        [_labelSecond setText:[NSString stringWithFormat:@"%d",seconds]];
    } else if (seconds < 10) {
        [_labelSecond setText:[NSString stringWithFormat:@"0%d",seconds]];
    }
    if (seconds == 0) {
        seconds = 60;
        minutes --;
        if (minutes == -1) {
            if (isWorking == true) {
                
                isWorking = false;
                totalWorking ++;
                [_labelTotalWorking setText:[NSString stringWithFormat:@"Number Of Time Working : %d",totalWorking]];

                if (_settingItem.switchOnOffLongBreak == 1) {
                    if (totalWorking > 0 && totalWorking % frequency == 0) {
                        totalLongBreaking ++;
                        minutes = _settingItem.timeLongBreak - 1;
                    } else {
                        minutes = _settingItem.timeBreak - 1;
                    }
                    [self setupLabelMinutesText:minutes + 1];
                } else if (_settingItem.switchOnOffLongBreak == 0) {
                    
                    minutes = _settingItem.timeBreak - 1;
                    [self setupLabelMinutesText:minutes + 1];
                    
                    DebugLog(@"TimeBreak;");
                }
            } else if (isWorking == false) {
                
                isWorking = true;
                totalBreaking ++;
                [_labelTotalBreaking setText:[NSString stringWithFormat:@"Number Of Time Breaking : %d", totalBreaking]];
                [_labelTotalLongBreaking setText:[NSString stringWithFormat:@"Number Of Time Long Breaking : %d",  totalLongBreaking]];
                minutes = _settingItem.timeWork - 1;
                [self setupLabelMinutesText:minutes + 1];
            }
        }
    }
    if (isWorking == true) {
        [_labelStatusWorking setText:@"Working"];
    } else {
        if (switchOnOffLongBreak == 1) {
            if (totalWorking > 0 && totalWorking % frequency == 0) {
                [_labelStatusWorking setText:@"Long Breaking"];
            } else {
                [_labelStatusWorking setText:@"Breaking"];
            }
        } else {
            [_labelStatusWorking setText:@"Breaking"];
        }
        
    }

}









@end
