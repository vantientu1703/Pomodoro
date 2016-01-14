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
#import "DataSoundManager.h"

@interface SoundListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrJingtones;
@end

@implementation SoundListViewController
{
    AVAudioPlayer *audio;
    NSUserDefaults *userDefaults;
    int jingtoneID;
    AppDelegate *appDelegate;
    SettingItem *settingItem;
    NSIndexPath *_indexPath;
    
    DataSoundManager *dataSoundManager;
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
    
    dataSoundManager = [DataSoundManager getSingleton];
    _arrJingtones = dataSoundManager.data;
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
    jingtoneID = (int)indexPath.row;
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
