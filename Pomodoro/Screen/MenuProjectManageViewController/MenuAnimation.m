//
//  MenuAnimation.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/30/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "MenuAnimation.h"
#import "GetProjectManageItemToDatabaseTask.h"
#import "AppDelegate.h"
#import "SettingItem.h"

@implementation MenuAnimation
{
    NSMutableArray *_arrProjectManageItems;
    MoneyDBController *_moneyDBController;
    UITableView *_tableView;
    NSInteger indexPathRowCell;
}
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        GetProjectManageItemToDatabaseTask *getProjectManageItemToDatabaseTask = [[GetProjectManageItemToDatabaseTask alloc] init];
        _moneyDBController = [MoneyDBController getInstance];
        _arrProjectManageItems = [getProjectManageItemToDatabaseTask getProjectManageItemToDatabase:_moneyDBController];
        [self setupView];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    return self;
}

- (void) setupView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    [self addSubview:_tableView];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrProjectManageItems.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    ProjectManageItem *projectManageItem = [[ProjectManageItem alloc] init];
    projectManageItem = [_arrProjectManageItems objectAtIndex:indexPath.row];
    cell.textLabel.text = projectManageItem.projectName;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProjectManageItem *projectManageItem = [[ProjectManageItem alloc] init];
    projectManageItem = [_arrProjectManageItems objectAtIndex:indexPath.row];
    
    NSUserDefaults *userDefaukts = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
    [userDefaukts setInteger:projectManageItem.projectID forKey:KEY_PROJECT_ID];
    NSArray *arr = [[NSArray alloc] initWithObjects:projectManageItem.projectName, nil];
    [userDefaukts setObject:arr forKey:KEY_PROCJECT_NAME];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    SettingItem *settingItem = appDelegate.settingItem;
    settingItem.projectID = projectManageItem.projectID;
    settingItem.projectName = projectManageItem.projectName;
    
    [_delegate closeMenuAnimation];
    
    indexPathRowCell = indexPath.row;
    [userDefaukts setInteger:indexPath.row forKey:KEY_INDEXPATH_ROW_MENU];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
    int index = (int)[userDefaults integerForKey:KEY_INDEXPATH_ROW_MENU];
    if (index == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [cell.textLabel setTextColor:[UIColor greenColor]];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}










@end

