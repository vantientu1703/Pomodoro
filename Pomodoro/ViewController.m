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

@interface ViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SWTableViewCellDelegate,UndoViewDelegate>

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
    
    TodoItem *_todoItemUndo;
    BOOL _isUndo;
    NSInteger _indexIsEditing;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _status = false;
    _isUndo = false;
    _indexIsEditing = -1;
    
    _txtItemTodo = [[UITextField alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 40)];
    [self.view addSubview:_txtItemTodo];
    [_txtItemTodo setBackgroundColor:[UIColor grayColor]];
    _txtItemTodo.placeholder = @"Adding new task";
    _txtItemTodo.textColor = [UIColor whiteColor];
    _txtItemTodo.hidden = YES;
    _txtItemTodo.delegate = self;

    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.translatesAutoresizingMaskIntoConstraints = YES;
    
    _moneyDBController = [MoneyDBController getInstance];
    
    _searchBar.delegate = self;
    _searchBar.frame = CGRectMake(0, 0, _tableView.bounds.size.width, 50);
    [_tableView addSubview:_searchBar];
    
    heightTableview = _tableView.bounds.size.height;
    widthTableview = _tableView.bounds.size.width;
    
    [self loadData];
    [self registerForKeyboardNotification];
}

- (void) loadData {

    if (_segmentControl.selectedSegmentIndex == 0) {
        
        _arrTodos = [GetToDoItemToDatabase getTodoItemToDatabase:_moneyDBController where:@[@"0",@"0"]];
        
        _arrTodosRe_Oder = [GetToDoItemToDatabase getTodoItemToDatabase:_moneyDBController where:@[@"0",@"0"]];
        DebugLog(@"arrTodos: %@",_arrTodos);
        [self.tableView reloadData];
    } else {
        _arrTodos = [GetToDoItemToDatabase getTodoItemToDatabase:_moneyDBController where:@[@"1",@"0"]];
        [self.tableView reloadData];
    }
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
            [_txtItemTodo resignFirstResponder];
            [self loadData];
            //[self.tableView reloadData];
            break;
            
        default:
            break;
    }
}

- (IBAction)addItem:(id)sender {
    
    _indexIsEditing = -1;
    _status = false;
    _segmentControl.selectedSegmentIndex = 0;
    
    [self loadData];
    
    
    if (_indexIsEditing == -1) {
        
        [_txtItemTodo becomeFirstResponder];
//        [_tableView setNeedsLayout];
    }
}

#pragma mark notification keyboard 

- (void) registerForKeyboardNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow : (NSNotification *) aNotification {
    
    NSDictionary *info = [aNotification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.keyboardContraint.constant = height + 40;
        _txtItemTodo.frame = CGRectMake(0, self.view.bounds.size.height - height - 40, keyboardFrame.size.width, 40);
        _txtItemTodo.hidden = NO;
        
    } completion:^(BOOL finished) {
    
        [self.tableView layoutIfNeeded];
        if (_arrTodos.count > 0) {
            
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_arrTodos.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
    }];
    
}

- (void) keyboardWillBeHidden: (NSNotification *) aNotification {
    
    NSDictionary *info = [aNotification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.keyboardContraint.constant = -height - 40;
        //[self.tableView setNeedsLayout];
        
        _txtItemTodo.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 40);
        _txtItemTodo.hidden = YES;
    }  completion:^(BOOL finished) {
        [self loadData];
        CGRect frame = self.tableView.frame;
        frame.size.height = self.tableView.contentSize.height;
        self.tableView.frame = frame;
    }];
    
}


#pragma  mark TextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    NSIndexPath *indexPathSelected = [NSIndexPath indexPathForRow:_indexIsEditing inSection:0];
    CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathSelected];
    DebugLog(@"%@",cell.txtTask.text);
    
    if ([_txtItemTodo.text isEqual:@""]) {
            
        _txtItemTodo.hidden = YES;
        [_txtItemTodo resignFirstResponder];

    } else {
            
        _txtItemTodo.hidden = YES;
        _todoItem = [[TodoItem alloc] init];
        _todoItem.content = _txtItemTodo.text;
        
        [_moneyDBController insert:@"todos" data:[DBUtil ToDoItemToDBItem:_todoItem ]];
        
        [self loadData];
        [_txtItemTodo resignFirstResponder];
        _txtItemTodo.text = @"";
    }
    [self loadData];
    
    return YES;
}

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
    
    if (indexPath.row == _indexIsEditing) {
        
        [cell.txtTask becomeFirstResponder];
    }
    //cell.txtTask.tag = indexPath.row;
    cell.txtTask.text = todoItem.content;
    
    cell.txtTask.delegate = self;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

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

//- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    DebugLog(@"Swipe row at index: %ld", (long)indexPath.row);
//    return YES;
//}

//- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
//    
//    return YES;
//}

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
     NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    _indexPathRow = indexPath.row;
    if (index == 0) {
        
        TodoItem *todoItemRemoveFromTable = [_arrTodos objectAtIndex:indexPath.row];
        _todoItemUndo = todoItemRemoveFromTable;
        
        UpdateToDoItemToDatabase *updateTodoItemToDatabaseTask = [[UpdateToDoItemToDatabase alloc] initWithTodoItem:todoItemRemoveFromTable];
        [updateTodoItemToDatabaseTask doQuery:_moneyDBController];
        
        [self.arrTodos removeObject:todoItemRemoveFromTable];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView reloadData];
        
        if (_undoView) {
            
            [_undoView removeFromSuperview];
            [self animateUndoViewDisplay];
        } else {
            
            [self animateUndoViewDisplay];
        }
        _isUndo = false;
        
        [self performSelector:@selector(deleteRowFromTableview) withObject:self afterDelay:3];
        DebugLog(@"Press button is delete");
    }
    // index = 1 button is edit
    if (index == 1) {
    
        _indexIsEditing = indexPath.row;
        
        [self.tableView reloadData];
        DebugLog(@"press button is edit");
        DebugLog(@"indexEditing: %ld", (long)_indexIsEditing);
    }
}

#pragma mark UndoDelegate

- (void) undoHandle {
    
    _isUndo = true;
    DebugLog(@"Undo is press");
    [_arrTodos insertObject:_todoItemUndo atIndex:_indexPathRow];
    [self.tableView reloadData];
    [self animateUndoViewWillBeHidden];
}
- (void) removeUndoView {
    
    [self animateUndoViewWillBeHidden];
}
#pragma mark delete row tableview

- (void) deleteRowFromTableview  {
    
    if (_isUndo == false) {
        
        _todoItemUndo.isDelete = true;
        
        UpdateToDoItemToDatabase *updateTodoItemToDatabaseTask = [[UpdateToDoItemToDatabase alloc] initWithTodoItem:_todoItemUndo];
        [updateTodoItemToDatabaseTask doQuery:_moneyDBController];
        
        DebugLog(@"deleted todoItem mat roi");
        [self animateUndoViewWillBeHidden];
    }
}

#pragma mark init UndoView and animate

- (void) animateUndoViewDisplay {
    
    _undoView = [[UndoView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width * 2 / 3, 50)];
    _undoView.delegate = self;
    _undoView.center = CGPointMake(self.view.bounds.size.width / 3 + 10, self.view.bounds.size.height + 10);
    _undoView.layer.cornerRadius = 3;
    
    [self.view addSubview:_undoView];
    [UIView animateWithDuration:0.3 animations:^{
        
        _undoView.center = CGPointMake(self.view.bounds.size.width / 3 + 10, self.view.bounds.size.height - 40);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _undoView.center = CGPointMake(self.view.bounds.size.width / 3 + 10, self.view.bounds.size.height - 30);
        } completion:nil];
        
    }];
}

- (void) animateUndoViewWillBeHidden {
    
    [UIView animateWithDuration:0.1 animations:^{
        
        _undoView.center = CGPointMake(self.view.bounds.size.width / 3 + 10, self.view.bounds.size.height + 10);
    } completion:^(BOOL finished) {
        [_undoView removeFromSuperview];
    }];
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
