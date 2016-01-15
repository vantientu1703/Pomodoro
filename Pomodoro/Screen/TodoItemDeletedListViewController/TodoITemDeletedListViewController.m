//
//  TodoITemDeletedListViewController.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/2/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "TodoITemDeletedListViewController.h"
#import "GetTodoItemIsDeletedTask.h"
#import "TodoItem.h"
#import "CustomTableViewCell.h"
#import "SWTableViewCell.h"
#import "UpdateToDoItemToDatabase.h"
#import "GetTodoItemInProjectToDatabaseTask.h"


@interface TodoITemDeletedListViewController () <UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>

@property (nonatomic,strong) MoneyDBController *moneyDBController;
@property (nonatomic,strong) NSMutableArray *arrTodoItemIsDeleted;
@end

@implementation TodoITemDeletedListViewController
{
    NSMutableArray *_arrTitleSections;
    NSMutableDictionary *_todoItemIsDeletedDictionarys;
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _moneyDBController = [MoneyDBController getInstance];
    [self loadData];
}

- (void) loadData {
    
    GetTodoItemIsDeletedTask *getTodoItemIsDeletedTask = [[GetTodoItemIsDeletedTask alloc] init];
    _arrTodoItemIsDeleted = [getTodoItemIsDeletedTask getTodoItemToDatabase:_moneyDBController ];
    if (_arrTodoItemIsDeleted.count != 0) {
        _arrTitleSections = [[NSMutableArray alloc] init];
        TodoItem *todoItem = [[TodoItem alloc] init];
        todoItem = [_arrTodoItemIsDeleted objectAtIndex:0];
        
        NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
        [dateFomatter setDateFormat:@"yyyy - MM - dd"];
        
        NSString *dateTodoItem = [dateFomatter stringFromDate:todoItem.dateDeleted];
        [_arrTitleSections addObject:dateTodoItem];
        
        for (int i = 0; i < _arrTodoItemIsDeleted.count; i++) {
            
            TodoItem *todoItemCompare = [_arrTodoItemIsDeleted objectAtIndex:i];
            NSString *dateTodoItemCompare = [dateFomatter stringFromDate:todoItemCompare.dateDeleted];
            BOOL tmp = true;
            for (int j = 0; j < _arrTitleSections.count; j ++) {
                
                NSString *dateCompare = [_arrTitleSections objectAtIndex:j];
                if ([dateCompare isEqual:dateTodoItemCompare]) {
                    tmp = false;
                }
            }
            if (tmp != false) {
                
                [_arrTitleSections addObject:dateTodoItemCompare];
            }
        }
        NSMutableDictionary *todoItemDictionarys = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < _arrTitleSections.count; i ++) {
            NSMutableArray *arrTodoItems = [[NSMutableArray alloc] init];
            NSString *keyDate = [_arrTitleSections objectAtIndex:i];
            for (int j = 0; j < _arrTodoItemIsDeleted.count; j ++) {
                
                TodoItem *todoItemDict = [[TodoItem alloc] init];
                todoItemDict = [_arrTodoItemIsDeleted objectAtIndex:j];
                NSString *dateString = [dateFomatter stringFromDate: todoItemDict.dateDeleted];
                if ([keyDate isEqual:dateString]) {
                    
                    [arrTodoItems addObject:todoItemDict];
                }
            }
            [todoItemDictionarys setObject:arrTodoItems forKey:keyDate];
        }
        _todoItemIsDeletedDictionarys = todoItemDictionarys;
    }
    [self.tableView reloadData];
}

#pragma mark tableviewcell

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _arrTitleSections.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *titleSection = [_arrTitleSections objectAtIndex:section];
    NSArray *arrRows = [_todoItemIsDeletedDictionarys objectForKey:titleSection];
    return arrRows.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifer = @"CellIdentifer";
    
    CustomTableViewCell  *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    if (cell == nil) {
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell = [xib objectAtIndex:0];
    }
    
    TodoItem *todoItem = [[TodoItem alloc] init];
    NSString *titleSection = [_arrTitleSections objectAtIndex:indexPath.section];
    NSArray *arrTodoItem = [_todoItemIsDeletedDictionarys objectForKey:titleSection];
    todoItem = [arrTodoItem objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    [dateFomatter setDateFormat:@"hh:mm a"];
    
    GetTodoItemInProjectToDatabaseTask *getTodoItemInProjectToDatabaseTask = [[GetTodoItemInProjectToDatabaseTask alloc] init];
    NSArray *arrProject = [getTodoItemInProjectToDatabaseTask getTodoItemInProjectToDatabase:_moneyDBController whereID:todoItem.projectID];
    ProjectManageItem *projectManageItem = [ProjectManageItem new];
    projectManageItem =[arrProject objectAtIndex:0];
    
    cell.txtTask.enabled = NO;
    cell.delegate = self;
    cell.rightUtilityButtons = [self rightButtons];
    cell.leftUtilityButtons = [self leftButtons];
    
    cell.labelPomodoros.text = [NSString stringWithFormat:@"%@", [dateFomatter stringFromDate:todoItem.dateDeleted]];
    cell.txtTask.text = todoItem.content;
    cell.labelTime.text = [NSString stringWithFormat:@"Project : %@", projectManageItem.projectName];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 59, [[UIScreen mainScreen] bounds].size.width - 10, 1)];/// change size as you need.
    separatorLineView.backgroundColor = [UIColor lightGrayColor];
    separatorLineView.alpha = 0.7f;// you can also put image here
    [cell.contentView addSubview:separatorLineView];
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [_arrTitleSections objectAtIndex:section];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark Delegate SWTableViewCell

- (NSArray *) rightButtons {
    
    NSMutableArray *rightButtons = [[NSMutableArray alloc] init];
    
    [rightButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0] title:@"UnDelete"];
    return rightButtons;
}

- (NSArray *) leftButtons {
    return 0;
}

- (void) swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    // index = 0 Button is UnDelete;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (index == 0) {
        
        DebugLog(@"press is Undelete");
        NSString *titleSection = [_arrTitleSections objectAtIndex:indexPath.section];
        NSMutableArray *arrTodoItemIsDeleted = [_todoItemIsDeletedDictionarys objectForKey:titleSection];
        TodoItem *todoItem = [[TodoItem alloc] init];
        todoItem = [arrTodoItemIsDeleted objectAtIndex:indexPath.row];
        todoItem.isDelete = false;
        
        UpdateToDoItemToDatabase *updateTodoItemToDatabaseTask = [[UpdateToDoItemToDatabase alloc] initWithTodoItem:todoItem];
        [updateTodoItemToDatabaseTask doQuery:_moneyDBController];
        
        [arrTodoItemIsDeleted removeObjectAtIndex:indexPath.row];
        [_todoItemIsDeletedDictionarys setObject:arrTodoItemIsDeleted forKey:titleSection];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        [self.tableView reloadData];
    }
}











@end
