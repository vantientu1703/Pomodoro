//
//  SoundListViewController.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 1/12/16.
//  Copyright © 2016 ZooStudio. All rights reserved.
//

#import "SoundListViewController.h"
#import "JingtoneItem.h"
#import <AVFoundation/AVFoundation.h>
#import "SettingItem.h"
#import "AppDelegate.h"


@interface SoundListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrJingtones;
@end

@implementation SoundListViewController
{
    AVAudioPlayer *audio;
    NSUserDefaults *userDefaults;
    int jingtoneID;
    AppDelegate *appDelegate;
    SettingItem *settingItem;
    NSIndexPath *_indexPath;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    settingItem = appDelegate.settingItem;
    TodoItem *todoItem = settingItem.todoItem;
    
    userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    jingtoneID = todoItem.jingtoneID;
    [self loadJingtones];
}

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
}

#pragma mark - implement button save

- (IBAction)saveOnClicked:(id)sender {
    [audio stop];
     [self.delegate selectJingtone:jingtoneID];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrJingtones.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    JingtoneItem *jingtoneItem = [[JingtoneItem alloc] init];
    jingtoneItem = _arrJingtones[indexPath.row];
    cell.textLabel.text = jingtoneItem.nameSong;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
#pragma mark - TableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [audio stop];
    JingtoneItem *jingtoneItem = [[JingtoneItem alloc] init];
    jingtoneItem = _arrJingtones[indexPath.row];
    [self playJingtone:jingtoneItem.filePath];
    jingtoneID = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (jingtoneID == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}
- (void) playJingtone: (NSString *) filePath {
    
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:filePath ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:soundFile];
    NSError *error;
    
    audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [audio prepareToPlay];
    [audio play];
}






















@end
