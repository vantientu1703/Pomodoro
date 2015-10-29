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
#import "UndoView.h"


@interface ViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SWTableViewCellDelegate>

@property (nonatomic, strong) MoneyDBController *moneyDBController;
@property (nonatomic, strong) TodoItem *todoItem;
@property (nonatomic, strong) NSMutableArray *arrTodos;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, assign) NSInteger indexPathRow;
@property (nonatomic, assign) CGFloat heightKeyboard;
@property (nonatomic, strong) NSMutableArray *arrTodosRe_Oder;
@property (nonatomic, strong) UndoView *undoView;

@end

@implementation ViewController
{
    int heightTableview, widthTableview;
    
    NSInteger _sourceIndexOfRow, _destinationIndexPathOfRow;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _status = false;
    
    _txtItemTodo = [[UITextField alloc] init];
    [self.view addSubview:_txtItemTodo];
    [_txtItemTodo setBackgroundColor:[UIColor grayColor]];
    _txtItemTodo.placeholder = @"Adding new task";
    _txtItemTodo.textColor = [UIColor whiteColor];
    _txtItemTodo.hidden = YES;
    _txtItemTodo.delegate = self;
    _txtItemTodo.tag = 1;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _searchBar.delegate = self;
    _moneyDBController = [MoneyDBController getInstance];
    
    _searchBar.frame = CGRectMake(0, 0, _tableView.bounds.size.width, 50);
    [_tableView addSubview:_searchBar];
    
    heightTableview = _tableView.bounds.size.height;
    widthTableview = _tableView.bounds.size.width;
    [self loadData];
    [self registerForKeyboardNotification];
}

- (void) loadData {

    _arrTodos = [GetToDoItemToDatabase getTodoItemToDatabase:_moneyDBController where:@[@"0",@"0"]];
    
    _arrTodosRe_Oder = [GetToDoItemToDatabase getTodoItemToDatabase:_moneyDBController where:@[@"0",@"0"]];
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


- (IBAction)editOnClicked:(id)sender {
    
    if (![self.tableView isEditing]) {
        
        [_tableView setEditing:YES animated:YES];
        [_editButton setTitle:@"Done"];
        
        
    } else {
        
        [_tableView setEditing:NO animated:YES];
        [_editButton setTitle:@"Edit"];
        DebugLog(@"YES");
        DebugLog(@"Source %ld - destination %ld", (long)_sourceIndexOfRow, (long)_destinationIndexPathOfRow);
        
        if (_sourceIndexOfRow < _destinationIndexPathOfRow) {
            
            DebugLog(@"Sau khi sap xep");
            for (NSInteger i = _sourceIndexOfRow; i <= _destinationIndexPathOfRow; i++) {
                
                TodoItem *todoItem = [[TodoItem alloc] init];
                todoItem = [_arrTodos objectAtIndex:i];
                
                TodoItem *todosItemReOder = [[TodoItem alloc] init];
                todosItemReOder = [_arrTodosRe_Oder objectAtIndex:i];
                todosItemReOder.content = todoItem.content;
                todosItemReOder.status = todoItem.status;

                UpdateToDoItemToDatabase *updateTodoItemTask = [[UpdateToDoItemToDatabase alloc]initWithTodoItem:todosItemReOder];
                [updateTodoItemTask doQuery:_moneyDBController];
            }
        } else {
            
            DebugLog(@"Sau khi sap xep");
            for (NSInteger i = _destinationIndexPathOfRow; i <= _sourceIndexOfRow; i++) {
                
                TodoItem *todoItem = [[TodoItem alloc] init];
                todoItem = [_arrTodos objectAtIndex:i];
            }
        }
    }
}

- (IBAction)segrumentOnClicked:(id)sender {
    
    switch (_segmentControl.selectedSegmentIndex) {
        case 0:
            
            _status = false;
            [self loadData];
            //[self.tableView reloadData];
            break;
            
        case 1:
            
            _status = true;
            _arrTodos = [GetToDoItemToDatabase getTodoItemToDatabase:_moneyDBController where:@[@"1",@"0"]];
            [_txtItemTodo resignFirstResponder];
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }

}

- (IBAction)addItem:(id)sender {
    
    _segmentControl.selectedSegmentIndex = 0;
    [self loadData];
    [_txtItemTodo becomeFirstResponder];
    _status = false;

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
    
    _heightKeyboard = keyboardRect.size.height + 40;
    
    _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, widthTableview, heightTableview - _heightKeyboard);
    if (_arrTodos.count != 0) {
        
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_arrTodos.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    
}

- (void) keyboardWillBeHidden: (NSNotification *) aNotification {
    
    _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, widthTableview, heightTableview + _heightKeyboard);
    
    _txtItemTodo.hidden = YES;
}


#pragma  mark TextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 1) {
        
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
            [self registerForKeyboardNotification];
        } else {
            
            _todoItem = [[TodoItem alloc] init];
            _todoItem.content = _txtItemTodo.text;
            
            [_moneyDBController insert:@"todos" data:[DBUtil ToDoItemToDBItem:_todoItem ]];
            
            [self loadData];
            [_txtItemTodo resignFirstResponder];
            _txtItemTodo.text = @"";
        }
    } else if (textField.tag == 2 ) {
        
        [textField resignFirstResponder];
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
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
    
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        
        cell = [xib objectAtIndex:0];
    }
    
    if (_status == false) {
        
        cell.leftUtilityButtons = [self leftButtonsStatusFalse];
        cell.rightUtilityButtons = [self rightButtonsStatusFalse];
    } else {
        
        cell.leftUtilityButtons = [self leftButtonsStatusTrue];
        cell.rightUtilityButtons = [self rightButtonsStatusTrue];
    }
    
    cell.delegate = self;
    
    TodoItem *todoItem = [[TodoItem alloc] init];
    
    todoItem = [_arrTodos objectAtIndex:indexPath.row];
    
    cell.txtTask.tag = 2;
    cell.txtTask.text = todoItem.content;
    
    cell.txtTask.delegate = self;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
- (NSArray *) rightButtonsStatusFalse {
    
    NSMutableArray *rightUtilitylButtons = [[NSMutableArray alloc] init];
    
    [rightUtilitylButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0] title:@"Delete"];
    
    [rightUtilitylButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.16f green:0.36f blue:0.82f alpha:1.0] title:@"Edit"];
    
    return rightUtilitylButtons;
}

- (NSArray *) rightButtonsStatusTrue {
    
    NSMutableArray *rightUtilitylButtons = [[NSMutableArray alloc] init];
    
    [rightUtilitylButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0] title:@"Delete"];
    
    //[rightUtilitylButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.16f green:0.36f blue:0.82f alpha:1.0] title:@"Edit"];
    
    return rightUtilitylButtons;
}
- (NSArray *) leftButtonsStatusFalse {
    
        NSMutableArray *leftUtilityButtons = [[NSMutableArray alloc] init];
        
        [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.07f green:0.75f blue:0.16f alpha:1.0] title:@"Done"];
    
    return leftUtilityButtons;
}

- (NSArray *) leftButtonsStatusTrue {
    
    NSMutableArray *leftUtilityButtons = [[NSMutableArray alloc] init];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.07f green:0.75f blue:0.16f alpha:1.0] title:@"UnDone"];
    
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
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView reloadData];
            
        } else {
        
            // Undone
            todoItem.status = false;
            
            UpdateToDoItemToDatabase *updateTodoItemTask = [[UpdateToDoItemToDatabase alloc]initWithTodoItem:todoItem];
            [updateTodoItemTask doQuery:_moneyDBController];
            
            DebugLog(@"update was accessesfully");
            
            [self.arrTodos removeObject:todoItem];
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView reloadData];
        }
        
    }
}

- (void) swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    // index = 0 button is delete
    
    if (index == 0) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        TodoItem *todoItemRemoveFromTable = [_arrTodos objectAtIndex:indexPath.row];
        todoItemRemoveFromTable.isDelete = true;
        
        UpdateToDoItemToDatabase *updateTodoItemToDatabaseTask = [[UpdateToDoItemToDatabase alloc] initWithTodoItem:todoItemRemoveFromTable];
        [updateTodoItemToDatabaseTask doQuery:_moneyDBController];
        
        [self.arrTodos removeObject:todoItemRemoveFromTable];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView reloadData];
        
        [self animateUndoViewDisplay];
    }
    // index = 1 button is edit
    if (index == 1) {
        
        DebugLog(@"press button is edit");
    }
}

#pragma mark init UndoView and animate

- (void) animateUndoViewDisplay {
    
    if (!_undoView) {
        
        _undoView = [[UndoView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 4, self.view.bounds.size.height - 30, self.view.bounds.size.width * 2 / 3, 30)];
        _undoView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height + 10);
        _undoView.layer.cornerRadius = 10;
        [self.view addSubview:_undoView];
        [UIView animateWithDuration:0.3 animations:^{
            
            _undoView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 40);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.2 animations:^{
                _undoView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height - 30);
            } completion:nil];
            
        }];
    }
    
}

#pragma mark table view edit

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleNone;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    TodoItem *todoItem = [[TodoItem alloc] init];
    todoItem = [_arrTodos objectAtIndex:sourceIndexPath.row];
    
    _sourceIndexOfRow = sourceIndexPath.row;

    [_arrTodos removeObjectAtIndex:sourceIndexPath.row];
    [_arrTodos insertObject:todoItem atIndex:destinationIndexPath.row];
    
        _destinationIndexPathOfRow = destinationIndexPath.row;
    
    DebugLog(@"%ld - %ld",(long)_sourceIndexOfRow, (long)_destinationIndexPathOfRow);
}

- (NSIndexPath *) tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    return proposedDestinationIndexPath;
}










@end
