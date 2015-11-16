//
//  SettingTimerViewController.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/13/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTimerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *changeTimerWork;

@property (weak, nonatomic) IBOutlet UISegmentedControl *changeTimerBreak;

@property (weak, nonatomic) IBOutlet UISegmentedControl *changeTimerLongBreak;

@property (weak, nonatomic) IBOutlet UISegmentedControl *changeFrequency;
//label
@property (weak, nonatomic) IBOutlet UILabel *labelTimerWork;

@property (weak, nonatomic) IBOutlet UILabel *labelTimerBreak;

@property (weak, nonatomic) IBOutlet UILabel *labelTimerLongBreak;
@property (weak, nonatomic) IBOutlet UILabel *labelFrequency;

@property (weak, nonatomic) IBOutlet UISwitch *switchLongBreak;
@end
