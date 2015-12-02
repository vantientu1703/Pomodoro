//
//  MenuProjectManageTableViewController.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/30/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "MenuProjectManageTableViewController.h"
#import "GetProjectManageItemToDatabaseTask.h"

@interface MenuProjectManageTableViewController ()

@property (nonatomic, strong) NSMutableArray *arrProjectManages;
@property (nonatomic, strong) MoneyDBController *moneyDBController;
@end

@implementation MenuProjectManageTableViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _moneyDBController = [MoneyDBController getInstance];
    GetProjectManageItemToDatabaseTask *getProjectManageItemToDatabase = [[GetProjectManageItemToDatabaseTask alloc] init];
    _arrProjectManages = [getProjectManageItemToDatabase getProjectManageItemToDatabase:_moneyDBController];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrProjectManages.count;
}
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Project Manage";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    ProjectManageItem *projectManageItem = [[ProjectManageItem alloc] init];
    projectManageItem = [_arrProjectManages objectAtIndex:indexPath.row];
    cell.textLabel.text = projectManageItem.projectName;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
