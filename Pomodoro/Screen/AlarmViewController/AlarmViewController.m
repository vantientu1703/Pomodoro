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

@property (nonatomic, strong) NSMutableArray *arrJingtones;

@property (nonatomic, strong) MoneyDBController *moneyDBController;
@end

@implementation AlarmViewController
{
    BOOL enableAlarm;
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
    [self setup];
}

- (void) setup {
    
    [self loadJingtones];
    
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
    }
}

- (void) registerLocalNotification: (int) jingtoneID {
    JingtoneItem *jingtoneItem = [[JingtoneItem alloc] init];
    jingtoneItem = _arrJingtones[jingtoneID];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = _todoItem.content;
    localNotification.fireDate = _datePicker.date;
    localNotification.soundName = [NSString stringWithFormat:@"%@.mp3", jingtoneItem.filePath];
    localNotification.alertAction = @"Go on application";
    localNotification.category = @"Email";
    
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

- (void) loadJingtones {
    self.arrJingtones = [[NSMutableArray alloc] init];
    
    JingtoneItem *jingtoneItem = [[JingtoneItem alloc] init];
    jingtoneItem.nameSong = @"Aloha";
    jingtoneItem.filePath = @"aloha";
    [self.arrJingtones addObject:jingtoneItem];
    
    JingtoneItem *jingtoneItem1 = [[JingtoneItem alloc] init];
    jingtoneItem1.nameSong = @"Blue";
    jingtoneItem1.filePath = @"blue";
    [self.arrJingtones addObject:jingtoneItem1];
    
    JingtoneItem *jingtoneItem2 = [[JingtoneItem alloc] init];
    jingtoneItem2.nameSong = @"Con heo đất";
    jingtoneItem2.filePath = @"conheodat";
    [self.arrJingtones addObject:jingtoneItem2];
    
    JingtoneItem *jingtoneItem3 = [[JingtoneItem alloc] init];
    jingtoneItem3.nameSong = @"Criminal";
    jingtoneItem3.filePath = @"criminal";
    [self.arrJingtones addObject:jingtoneItem3];
    
    JingtoneItem *jingtoneItem4 = [[JingtoneItem alloc] init];
    jingtoneItem4.nameSong = @"Cười";
    jingtoneItem4.filePath = @"cuoi";
    [self.arrJingtones addObject:jingtoneItem4];
    
    JingtoneItem *jingtoneItem5 = [[JingtoneItem alloc] init];
    jingtoneItem5.nameSong = @"Day By Day";
    jingtoneItem5.filePath = @"daybyday";
    [self.arrJingtones addObject:jingtoneItem5];
    
    JingtoneItem *jingtoneItem6 = [[JingtoneItem alloc] init];
    jingtoneItem6.nameSong = @"Face";
    jingtoneItem6.filePath = @"face";
    [self.arrJingtones addObject:jingtoneItem6];
    
    JingtoneItem *jingtoneItem7 = [[JingtoneItem alloc] init];
    jingtoneItem7.nameSong = @"Forever";
    jingtoneItem7.filePath = @"forever";
    [self.arrJingtones addObject:jingtoneItem7];
    
    JingtoneItem *jingtoneItem8 = [[JingtoneItem alloc] init];
    jingtoneItem8.nameSong = @"Gangnam Style";
    jingtoneItem8.filePath = @"gangnamstyle";
    [self.arrJingtones addObject:jingtoneItem8];
    
    JingtoneItem *jingtoneItem9 = [[JingtoneItem alloc] init];
    jingtoneItem9.nameSong = @"Heartbreaker";
    jingtoneItem9.filePath = @"heartbreaker";
    [self.arrJingtones addObject:jingtoneItem9];
    
    JingtoneItem *jingtoneItem10 = [[JingtoneItem alloc] init];
    jingtoneItem10.nameSong = @"Jingle Bells";
    jingtoneItem10.filePath = @"jinglebells";
    [self.arrJingtones addObject:jingtoneItem10];
    
    JingtoneItem *jingtoneItem11 = [[JingtoneItem alloc] init];
    jingtoneItem11.nameSong = @"Last Farewell";
    jingtoneItem11.filePath = @"lastfarewell";
    [self.arrJingtones addObject:jingtoneItem11];
    
    JingtoneItem *jingtoneItem12 = [[JingtoneItem alloc] init];
    jingtoneItem12.nameSong = @"Lucky";
    jingtoneItem12.filePath = @"lucky";
    [self.arrJingtones addObject:jingtoneItem12];
    
    JingtoneItem *jingtoneItem13 = [[JingtoneItem alloc] init];
    jingtoneItem13.nameSong = @"Midnight";
    jingtoneItem13.filePath = @"midnight";
    [self.arrJingtones addObject:jingtoneItem13];
    
    JingtoneItem *jingtoneItem14 = [[JingtoneItem alloc] init];
    jingtoneItem14.nameSong = @"Nếu";
    jingtoneItem14.filePath = @"neu";
    [self.arrJingtones addObject:jingtoneItem14];
    
    JingtoneItem *jingtoneItem15 = [[JingtoneItem alloc] init];
    jingtoneItem15.nameSong = @"Nhốt em vào tim nhạc";
    jingtoneItem15.filePath = @"nhotemvaotimnhac";
    [self.arrJingtones addObject:jingtoneItem15];
    
    JingtoneItem *jingtoneItem16 = [[JingtoneItem alloc] init];
    jingtoneItem16.nameSong = @"Nobody";
    jingtoneItem16.filePath = @"nobody";
    [self.arrJingtones addObject:jingtoneItem16];
    
    JingtoneItem *jingtoneItem17 = [[JingtoneItem alloc] init];
    jingtoneItem17.nameSong = @"Nocturne";
    jingtoneItem17.filePath = @"nocturne";
    [self.arrJingtones addObject:jingtoneItem17];
    
    JingtoneItem *jingtoneItem18 = [[JingtoneItem alloc] init];
    jingtoneItem18.nameSong = @"Nỗi đau xót xa";
    jingtoneItem18.filePath = @"noidauxotxa";
    [self.arrJingtones addObject:jingtoneItem18];
    
    JingtoneItem *jingtoneItem19 = [[JingtoneItem alloc] init];
    jingtoneItem19.nameSong = @"Quên Cách Yêu";
    jingtoneItem19.filePath = @"quencachyeu";
    [self.arrJingtones addObject:jingtoneItem19];
    
    JingtoneItem *jingtoneItem20 = [[JingtoneItem alloc] init];
    jingtoneItem20.nameSong = @"Thu Cuối";
    jingtoneItem20.filePath = @"thucuoi";
    [self.arrJingtones addObject:jingtoneItem20];
    
    JingtoneItem *jingtoneItem21 = [[JingtoneItem alloc] init];
    jingtoneItem21.nameSong = @"Trouble Maker";
    jingtoneItem21.filePath = @"troublemaker";
    [self.arrJingtones addObject:jingtoneItem21];
    
    JingtoneItem *jingtoneItem22 = [[JingtoneItem alloc] init];
    jingtoneItem22.nameSong = @"Until You";
    jingtoneItem22.filePath = @"untilyou";
    [self.arrJingtones addObject:jingtoneItem22];
    
    //[userDefaults setObject:_arrJingtones forKey:@"key_arr_jingtones"];
}
@end

