//
//  AlarmViewController.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 1/8/16.
//  Copyright © 2016 ZooStudio. All rights reserved.;

//

#import "AlarmViewController.h"
#import "AppDelegate.h"
#import "SettingItem.h"
#import "SoundListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+KNSemiModal.h"
#import "JingtoneItem.h"
#import "UpdateToDoItemToDatabase.h"
#import "DataSoundManager.h"


@interface AlarmViewController () <SoundListViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *contentTaskLabel;
@property (weak, nonatomic) IBOutlet UISwitch *onOffAlarm;
@property (weak, nonatomic) IBOutlet UIButton *buttonSelectSound;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) TodoItem *todoItem;
@property (nonatomic, strong) SettingItem *settingItem;

@property (nonatomic, strong) NSArray *arrJingtones;

@property (nonatomic, strong) MoneyDBController *moneyDBController;
@end

@implementation AlarmViewController
{
    BOOL enableAlarm;
    DataSoundManager *dataSoundManager;
}
- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Alarm";
    _moneyDBController = [MoneyDBController getInstance];
    dataSoundManager = [DataSoundManager getSingleton];
    _arrJingtones = dataSoundManager.data;
    [self setup];
}

- (void) setup {
    
    //[self loadJingtones];
    
    JingtoneItem *jingtoneItem = [[JingtoneItem alloc] init];
    _appDelegate = [[UIApplication sharedApplication] delegate];
    _settingItem = _appDelegate.settingItem;
    _todoItem = _settingItem.todoItem;
    
    _onOffAlarm.on = _todoItem.enableAlarm;
    _contentTaskLabel.text = _todoItem.content;
    jingtoneItem = _arrJingtones[_todoItem.jingtoneID];
    _doneButton.layer.cornerRadius = 5;
    [_buttonSelectSound setTitle:jingtoneItem.nameSong forState:UIControlStateNormal];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM - yyyy"];
    if (![[dateFormatter stringFromDate:_todoItem.timeAlarm] isEqualToString:@"01 - 1970"]) {
        [_datePicker setDate:_todoItem.timeAlarm];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(semiModalDismissed:)
                                                 name:kSemiModalDidHideNotification
                                               object:nil];
}

#pragma mark NSNotificationCenter

- (void) semiModalDismissed: (NSNotification *) aNotification {
    
    DebugLog(@"datePicker: %@", _datePicker.date);
    if (_todoItem.enableAlarm) {
        _todoItem.timeAlarm = _datePicker.date;
        
        UpdateToDoItemToDatabase *updateTodoItemToDatabaseTask = [[UpdateToDoItemToDatabase alloc] initWithTodoItem:_todoItem];
        [updateTodoItemToDatabaseTask doQuery:_moneyDBController];
        [self registerLocalNotification:_todoItem.jingtoneID];
    } else {
        NSArray *arr = [[UIApplication sharedApplication] scheduledLocalNotifications];
        UILocalNotification *notifi = [[UILocalNotification alloc] init];
        
        for (int i = 0; i < arr.count; i ++) {
            notifi = arr[i];
            NSDictionary *dictionary = notifi.userInfo;
            NSString *stringUserInfo = dictionary [@"key_alarm"];
            if ([stringUserInfo isEqualToString:[NSString stringWithFormat:@"%ld - %ld",_todoItem.todo_id,_todoItem.projectID]]) {
                [[UIApplication sharedApplication] cancelLocalNotification:notifi];
            }
        }
    }
}

- (void) registerLocalNotification: (int) jingtoneID {
    JingtoneItem *jingtoneItem = [[JingtoneItem alloc] init];
    jingtoneItem = _arrJingtones[jingtoneID];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = _todoItem.content;
    localNotification.fireDate = _datePicker.date;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = [NSString stringWithFormat:@"%@.mp3", jingtoneItem.filePath];
    localNotification.alertAction = @"Go on application";
    localNotification.category = @"Email";

    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld - %ld",_todoItem.todo_id,_todoItem.projectID] forKey:@"key_alarm"];
    localNotification.userInfo = dictionary;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - implement button
- (IBAction)onOffAlarm:(id)sender {
    if (_onOffAlarm.on == NO) {
        enableAlarm = false;
        _todoItem.enableAlarm = false;
    } else {
        enableAlarm = true;
        _todoItem.enableAlarm = true;
    }
}

- (IBAction)selectSound:(id)sender {
    
    SoundListViewController *soundListViewController = [[SoundListViewController alloc] init];
    soundListViewController.delegate = self;
    [self presentViewController:soundListViewController animated:YES completion:nil];
}

#pragma mark - SoundListViewControllerDelegate

- (void) selectJingtone:(int)jingtoneID {
    
    _todoItem.jingtoneID = jingtoneID;
    _settingItem.todoItem = _todoItem;
    JingtoneItem *jingtoneItem = [[JingtoneItem alloc] init];
    jingtoneItem = _arrJingtones[jingtoneID];
    [_buttonSelectSound setTitle:jingtoneItem.nameSong forState:UIControlStateNormal];
}


#pragma mark - load jingtone

@end

