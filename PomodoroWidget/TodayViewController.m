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

@property (weak, nonatomic) IBOutlet UILabel *labelTimer;
//@property (nonatomic, strong) TimerNotificationcenterItem *timerNotificationCenterItem;
@property (nonatomic, strong) NSUserDefaults *shareUserDefaults;
@end

@implementation TodayViewController
{
    int i;
    NSTimer *timer;
}
//- (instancetype) initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super initWithCoder:aDecoder]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange:)
//                                                     name:NSUserDefaultsDidChangeNotification
//                                                   object:nil];
//    }
//    return self;
//}
- (void) viewWillAppear:(BOOL)animated {
}
- (void)viewDidLoad {
    [super viewDidLoad];
    i = 0;
    
    _shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self updateLabel];
}
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self
                                           selector:@selector(updateLabel)
                                           userInfo:nil
                                            repeats:YES];
    completionHandler(NCUpdateResultNewData);
}

- (IBAction)StartOnClicked:(id)sender {
    if ([[_shareUserDefaults stringForKey:@"keycheckappisrunning"] isEqualToString:@"appisstop"]) {
        NSURL *url = [NSURL URLWithString:@"pomodoro://"];
        [self.extensionContext openURL:url completionHandler:nil];
    } else {
        
    }
}

- (void) updateLabel {
    NSString *timeMinutes;
    NSString *timeSeconds;
    
    if ([_shareUserDefaults integerForKey:@"keytimeminutes"] < 10) {
        timeMinutes = [NSString stringWithFormat:@"0%ld", (long)[_shareUserDefaults integerForKey:@"keytimeminutes"]];
    } else {
         timeMinutes = [NSString stringWithFormat:@"%ld", (long)[_shareUserDefaults integerForKey:@"keytimeminutes"]];
    }
    
    if ([_shareUserDefaults integerForKey:@"keytimeseconds"] < 10) {
        timeSeconds = [NSString stringWithFormat:@"0%ld", (long)[_shareUserDefaults integerForKey:@"keytimeseconds"]];
    } else {
        timeSeconds = [NSString stringWithFormat:@"%ld", (long)[_shareUserDefaults integerForKey:@"keytimeseconds"]];
    }
    _labelTimer.text = [NSString stringWithFormat:@"%@ : %@", timeMinutes, timeSeconds];
}

- (UIEdgeInsets) widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    defaultMarginInsets.bottom = 20.0;
    return defaultMarginInsets;
}
@end
