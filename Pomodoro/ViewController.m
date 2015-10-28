//
//  ViewController.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "ViewController.h"
#import "MoneyDBController.h"
#import "TodoItem.h"
#import "DBUtil.h"
#import "GetToDoItemToDatabase.h"
#import "SWTableViewCell.h"
#import "UMTableViewCell.h"
#import "UpdateToDoItemToDatabase.h"
#import "CustomTableViewCell.h"
#import "DeleteTodoItemToDatabaseTask.h"

@interface ViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SWTableViewCellDelegate>

@property (nonatomic, strong) MoneyDBController *moneyDBController;
@property (nonatomic, strong) TodoItem *todoItem;
@property (nonatomic, strong) NSMutableArray *arrTodos;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, assign) NSInteger indexPathRow;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _status = false;
    
    _txtItemTodo = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [self.view addSubview:_txtItemTodo];
    [_txtItemTodo setBackgroundColor:[UIColor grayColor]];
    _txtItemTodo.placeholder = @"Adding new task";
    _txtItemTodo.textColor = [UIColor whiteColor];
    _txtItemTodo.hidden = YES;
    _txtItemTodo.delegate = self;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _searchBar.delegate = self;
    
    self.isEditing = false;
    
    _moneyDBController = [MoneyDBController getInstance];
    
    _searchBar.frame = CGRectMake(0, 0, _tableView.bounds.size.width, 50);
    [_tableView addSubview:_searchBar];
    [_tableView setEditing:YES animated:YES];
    
    
    [self loadData];
    [self addGestureRecognizer];
}

- (void) loadData {

    _arrTodos = [GetToDoItemToDatabase getTodoItemToDatabase:_moneyDBController where:[NSArray arrayWithObject:@"0"]];
    
    DebugLog(@"arrTodos: %@",_arrTodos);
    
    [self.tableView reloadData];
}

#pragma  mark add recognizer

- (void) addGestureRecognizer {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(didDismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tap];
}

- (void) didDismissKeyboard {
    
    [_txtItemTodo resignFirstResponder];
}
#pragma mark implement IBAC


- (IBAction)segrumentOnClicked:(id)sender {
    
    switch (_segmentControl.selectedSegmentIndex) {
        case 0:
            
            _status = false;
            [self loadData];
            break;
            
        case 1:
            
            _status = true;
            _arrTodos = [GetToDoItemToDatabase getTodoItemToDatabase:_moneyDBController where:[NSArray arrayWithObject:@"1"]];
            
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }

}

- (IBAction)addItem:(id)sender {
    
    [self registerForKeyboardNotification];
    _isEditing = false;
    [_txtItemTodo becomeFirstResponder];
    
    //[_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

#pragma mark notification keyboard 

- (void) registerForKeyboardNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) keyboardWasShown: (NSNotification *) aNotification {
    
    NSDictionary *info = [aNotification userInfo];
    NSValue *keyboardValue = [info valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardRect = [keyboardValue CGRectValue];
    
    _txtItemTodo.frame = CGRectMake(0, self.view.bounds.size.height - keyboardRect.size.height - 40, keyboardRect.size.width, 40);
    _txtItemTodo.hidden = NO;
}

- (void) keyboardWillBeHidden: (NSNotification *) aNotidication {
    
    _txtItemTodo.hidden = YES;
}


#pragma  mark TextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if ([_txtItemTodo.text isEqual:@""]) {
        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reminder" message:@"Missing to information" preferredStyle: UIAlertControllerStyleAlert];
//        
//        UIAlertAction *okAlert = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK Action") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            NSLog(@"OK Action");
//        }];
//        
//        [alertController addAction:okAlert];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
        
        [_txtItemTodo resignFirstResponder];
    } else {
        
        if (_isEditing == false) {
            
            _todoItem = [[TodoItem alloc] init];
            
            _todoItem.content = _txtItemTodo.text;
            
            [_moneyDBController insert:@"todos" data:[DBUtil ToDoItemToDBItem:_todoItem ]];
            
            [self loadData];
            
            [_txtItemTodo resignFirstResponder];
        } else if (_isEditing == true) {
            
            TodoItem *todoItem = [[TodoItem alloc] init];
            
            todoItem = [_arrTodos objectAtIndex:_indexPathRow];
            todoItem.content = _txtItemTodo.text;
            
            UpdateToDoItemToDatabase *updateTodoItemDatabaseTask = [[UpdateToDoItemToDatabase alloc] initWithTodoItem:todoItem];
            [updateTodoItemDatabaseTask doQuery:_moneyDBController];
            
            [self.tableView reloadData];
            
            [_txtItemTodo resignFirstResponder];
        }
        
        _txtItemTodo.hidden = YES;
        
        _txtItemTodo.text = @"";
    }

    return YES;
}

#pragma mark UISearchDelegate



#pragma mark table view

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _arrTodos.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    static NSString *cellIdentifer = @"cellIndetifer";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    //CustomTableViewCell *cell2 = (CustomTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    if (cell == nil) {
        
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifer];
        
    }
    
    cell.rightUtilityButtons = [self rightButtons];
    
    if (_status == false) {
        
        cell.leftUtilityButtons = [self leftButtonsStatusFalse];
    } else {
        
        cell.leftUtilityButtons = [self leftButtonsStatusTrue];
    }
    
    cell.delegate = self;
    
    TodoItem *todoItem = [[TodoItem alloc] init];
    
    todoItem = [_arrTodos objectAtIndex:indexPath.row];
    
    cell.textLabel.text = todoItem.content;
    
    
    
    //DebugLog(@"todoItem content: %@", todoItem.content);
    //[_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_txtItemTodo resignFirstResponder];
}

//- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    return @"Schedule";
//}
//
//
//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return 60;
//}
- (NSArray *) rightButtons {
    
    NSMutableArray *rightUtilitylButtons = [[NSMutableArray alloc] init];
    
    [rightUtilitylButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0] title:@"Delete"];
    
    [rightUtilitylButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.16f green:0.36f blue:0.82f alpha:1.0] title:@"Edit"];
    
    return rightUtilitylButtons;
}

- (NSArray *) leftButtonsStatusFalse {
    
        NSMutableArray *leftUtilityButtons = [[NSMutableArray alloc] init];
        
        [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.07f green:0.75f blue:0.16f alpha:1.0] title:@"Done"];
        
        DebugLog(@"Done button");
    
    return leftUtilityButtons;
}

- (NSArray *) leftButtonsStatusTrue {
    
    NSMutableArray *leftUtilityButtons = [[NSMutableArray alloc] init];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.07f green:0.75f blue:0.16f alpha:1.0] title:@"UnDone"];
    
    DebugLog(@"UnDone button");
    
    return leftUtilityButtons;
}

- (void) swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    //int indexDone = 0;
    
    if (index == 0) {
        
            DebugLog(@"you press button done");
            
            //TodoItem *todoItem = [[TodoItem alloc] init];
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            
            TodoItem *todoItem = _arrTodos [indexPath.row];
        
        if (_status == false) {
            
            todoItem.status = true;
            
            UpdateToDoItemToDatabase *updateTodoItemTask = [[UpdateToDoItemToDatabase alloc]initWithTodoItem:todoItem];
            [updateTodoItemTask doQuery:_moneyDBController];
            
            DebugLog(@"update was accessesfully");
            
            [self.arrTodos removeObject:todoItem];
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            
            todoItem.status = false;
            
            UpdateToDoItemToDatabase *updateTodoItemTask = [[UpdateToDoItemToDatabase alloc]initWithTodoItem:todoItem];
            [updateTodoItemTask doQuery:_moneyDBController];
            
            DebugLog(@"update was accessesfully");
            
            [self.arrTodos removeObject:todoItem];
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
}

- (void) swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    // index = 0 button is delete
    
    if (index == 0) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        TodoItem *todoItem = [_arrTodos objectAtIndex:indexPath.row];
        
        DeleteTodoItemToDatabaseTask *deleteTodoItemToDatabaseTask = [[DeleteTodoItemToDatabaseTask alloc] initWithTodoItem:todoItem];
        [deleteTodoItemToDatabaseTask doQuery:_moneyDBController];
        
        [self.arrTodos removeObject:todoItem];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        DebugLog(@"Press button delete");
    }
    
    // index = 1 button is edit
    if (index == 1) {
        
        _isEditing = true;
        [self registerForKeyboardNotification];
        [_txtItemTodo becomeFirstResponder];
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        TodoItem *todoItem = _arrTodos [indexPath.row];
        _indexPathRow = indexPath.row;
        
        _txtItemTodo.text = todoItem.content;
    }
}

#pragma mark table view edit 

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleNone;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    TodoItem *todoItem1 = [[TodoItem alloc] init];
    todoItem1 = [_arrTodos objectAtIndex:sourceIndexPath.row];
    
    [_arrTodos removeObjectAtIndex:sourceIndexPath.row];
    [_arrTodos insertObject:todoItem1 atIndex:destinationIndexPath.row];
    
}

- (NSIndexPath *) tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    return proposedDestinationIndexPath;
}










@end
