//
//  TableViewController.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "ProjectManageViewController.h"
#import "CustomTableViewCellProjectManage.h"
#import "AddProjectViewController.h"
#import "GetProjectManageItemToDatabaseTask.h"
#import "AppDelegate.h"
#import "GetToDoItemIsDoingToDatabase.h"
#import "GetTodoItemWasDoneOrderByDateCompletedTask.h"
#import "DetailProjectManageViewController.h"


@interface ProjectManageViewController () <UITextFieldDelegate,CustomTableViewProjectManageDelegate>

@property (nonatomic, strong) NSMutableArray *arrProjectManageItem;
@property (nonatomic, strong) NSMutableArray *arrTaskTodos;
@property (nonatomic, strong) NSMutableArray *arrTaskDones;
@property (nonatomic, strong) MoneyDBController *moneyDBController;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) SettingItem *settingItem;
@end

@implementation ProjectManageViewController
{
    UITextField *_txtAddProjectTextField;
    CGSize size;
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    size = [[UIScreen mainScreen] bounds].size;
    _moneyDBController = [MoneyDBController getInstance];
    _appDelegate = [[UIApplication sharedApplication] delegate];
    _settingItem = _appDelegate.settingItem;
    
    [self chooseData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushTabbarViewControllerIndex2) name:@"appDidBecomeActive"
                                               object:nil];
    //self.navigationItem.leftBarButtonItem = nil;
}
- (void) pushTabbarViewControllerIndex2 {
    self.tabBarController.selectedIndex = 1;
}
#pragma mark - chooseData

- (void) chooseData {
    
        self.title = @"Project Manage";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:nil];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                               target:self
                                                                                               action:@selector(addProjectManageItem)];
        [self loadData];
}

- (void) loadData {
    
    GetProjectManageItemToDatabaseTask *getProjectManageItemToDatabaseTask = [[GetProjectManageItemToDatabaseTask alloc] init];
    _arrProjectManageItem = [getProjectManageItemToDatabaseTask getProjectManageItemToDatabase:_moneyDBController];
    
    [self.tableView reloadData];
}
#pragma mark - add ProjectManageItem 

- (void) addProjectManageItem {
    
    AddProjectViewController *addProjectViewController = [AddProjectViewController new];
    addProjectViewController.stringTitle = @"add";
    [self.navigationController pushViewController:addProjectViewController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  _arrProjectManageItem.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *cellIdentifier = @"CellIdentifier";
    CustomTableViewCellProjectManage *cell = (CustomTableViewCellProjectManage *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCellProjectManage" owner:self options:nil];
        cell = [xib objectAtIndex:0];
    }
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    [dateFomatter setDateFormat:@"yyyy / MM / dd"];
    ProjectManageItem *projectManageItem = [[ProjectManageItem alloc] init];
    projectManageItem = [_arrProjectManageItem objectAtIndex:indexPath.row];
    
    cell.delegate = self;
    cell.labelProjectname.text = projectManageItem.projectName;
    
    if ([[dateFomatter stringFromDate:projectManageItem.endDate] isEqualToString:@"1970 / 01 / 01"]) {
        cell.labelStartEndDateTime.text = @": No select";
    } else {
        cell.labelStartEndDateTime.text = [NSString stringWithFormat:@": %@", [dateFomatter stringFromDate:projectManageItem.endDate]];
    }
    
    NSString *stringID = [NSString stringWithFormat:@"%ld", projectManageItem.projectID];
    NSArray *arr = [[NSArray alloc] initWithObjects:stringID, nil];
    
    _arrTaskTodos = [GetToDoItemIsDoingToDatabase getTodoItemToDatabase:_moneyDBController where:arr];
    
    GetTodoItemWasDoneOrderByDateCompletedTask *getTodoItemWasDoneOrderByDateCompleted = [[GetTodoItemWasDoneOrderByDateCompletedTask alloc] init];
    _arrTaskDones = [getTodoItemWasDoneOrderByDateCompleted getTodoItemToDatbase:_moneyDBController where:arr];
    
    cell.labelTotalTodo.text = [NSString stringWithFormat:@": %lu", (unsigned long)_arrTaskTodos.count];
    cell.labelTotalDone.text = [NSString stringWithFormat:@": %lu", (unsigned long)_arrTaskDones.count];
    cell.indexPath = indexPath;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProjectManageItem *projectManageItem = [[ProjectManageItem alloc] init];
    projectManageItem = [_arrProjectManageItem objectAtIndex:indexPath.row];
    
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setInteger:projectManageItem.projectID forKey:keyIndexRowProjectManage];
//    _settingItem.projectID = projectManageItem.projectID;
    
    DetailProjectManageViewController *detailProjectManageViewController = [[DetailProjectManageViewController alloc] init];
    detailProjectManageViewController.projectManageItem = projectManageItem;
    [self.navigationController pushViewController:detailProjectManageViewController animated:YES];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 125;
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
