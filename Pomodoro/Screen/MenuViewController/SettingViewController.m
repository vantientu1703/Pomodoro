//
//  MenuViewController.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/31/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "SettingViewController.h"
#import "GetTodoItemIsDeletedTask.h"
#import "CustomTableViewCell.h"
#import "SWTableViewCell.h"
#import "TodoItem.h"
#import "TodoITemDeletedListViewController.h"
#import "SettingTimerViewController.h"

#define CELL_HEIGHT 40
@interface SettingViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) MoneyDBController *moneyDBController;
@property (nonatomic, strong) NSMutableArray *arrTodoItemIsDeleted;
@property (nonatomic, strong) NSMutableArray *arrListTitle;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Setting";
    
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    
    _arrListTitle = [[NSMutableArray alloc] initWithArray:@[@"Trash",@"Options Timer"]];
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _arrListTitle.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifer = @"CellIndentifer";
    
    SWTableViewCell *cell =(SWTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    if (cell == nil) {
        
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifer];
    }
    cell.accessoryType = UITableViewCellSeparatorStyleSingleLine;
    cell.textLabel.text  = [_arrListTitle objectAtIndex:indexPath.row];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(10,40 - 1, [[UIScreen mainScreen] bounds].size.width - 10, 1)];/// change size as you need.
    separatorLineView.backgroundColor = [UIColor lightGrayColor];
    separatorLineView.alpha = 0.7f;// you can also put image here
    [cell.contentView addSubview:separatorLineView];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            TodoITemDeletedListViewController *todoItemDeletedListViewController = [[TodoITemDeletedListViewController alloc] init];
            todoItemDeletedListViewController.title = @"Trash";
            [self.navigationController pushViewController:todoItemDeletedListViewController animated:YES];
        }
            break;
            
        case 1:
        {
            SettingTimerViewController *settingTimerViewController;
            //if (!settingTimerViewController) {
                settingTimerViewController = [[SettingTimerViewController alloc] init];
            //}
            settingTimerViewController.title = @"Options Timer";
            [self.navigationController pushViewController:settingTimerViewController animated:YES];
        }
        default:
            break;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}
@end
