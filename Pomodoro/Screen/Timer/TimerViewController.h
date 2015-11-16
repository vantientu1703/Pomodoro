//
//  TimerViewController.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/13/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *labelMinute;

@property (weak, nonatomic) IBOutlet UILabel *labelSecond;

@property (weak, nonatomic) IBOutlet UIButton *buttonStart;

@property (weak, nonatomic) IBOutlet UILabel *labelStatusWorking;

@property (weak, nonatomic) IBOutlet UILabel *labelTotalWorking;

@property (weak, nonatomic) IBOutlet UILabel *labelTotalBreaking;

@property (weak, nonatomic) IBOutlet UILabel *labelTotalLongBreaking;

@end
