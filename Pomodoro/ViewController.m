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
#import "GetToDoItemIsDoingToDatabase.h"
#import "SWTableViewCell.h"
#import "UMTableViewCell.h"
#import "UpdateToDoItemToDatabase.h"
#import "CustomTableViewCell.h"
#import "DeleteTodoItemToDatabaseTask.h"
#import "UndoView.h"
#import "GetTodoItemWasDoneOrderByDateCompletedTask.h"
#import "AppDelegate.h"
#import "SettingItem.h"
#import "TimerNotificationcenterItem.h"
#import "AGPushNoteView.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SWTableViewCellDelegate,UndoViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) MoneyDBController *moneyDBController;
@property (nonatomic, strong) TodoItem *todoItem;
@property (nonatomic, strong) NSMutableArray *arrTodos;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, assign) NSInteger indexPathRow;
@property (nonatomic, assign) CGFloat heightKeyboard;
@property (nonatomic, strong) NSMutableArray *arrTodosRe_Oder;
@property (nonatomic, strong) UndoView *undoView;
@property (nonatomic, strong) NSMutableArray *arrTitleSections;

@end

@implementation ViewController
{
    int heightTableview, widthTableview;
    
    NSInteger _sourceIndexOfRow, _destinationIndexPathOfRow;
    
    TodoItem *_todoItemUndo;
    BOOL _isUndo;
    NSInteger _indexIsEditing;
    NSIndexPath *_indexPath;
    NSString *_contentTextTask;
    NSMutableDictionary *_todoItemDictionarys;
    UIBarButtonItem *_showEditBtn;
    CGSize size;
    NSInteger totalTodos;
    AppDelegate *appDelegate;
    BOOL isStartting;
    TimerNotificationcenterItem *timerNotificationCenterItem;
    SettingItem *_settingItem;
    AVAudioPlayer *audioPlayer;
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    size = [[UIScreen mainScreen] bounds].size;
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    timerNotificationCenterItem = appDelegate.timerNotificationcenterItem;
    _settingItem = appDelegate.settingItem;
    
    _segmentControl.selectedSegmentIndex = 0;
    [self loadData];
    
    totalTodos = _arrTodos.count;
    
    if (totalTodos > 0) {
        [_segmentControl setTitle:[NSString stringWithFormat:@"To Do (%lu)",totalTodos]
                forSegmentAtIndex:0];
    } else {
        [_segmentControl setTitle:[NSString stringWithFormat:@"To Do"] forSegmentAtIndex:0];
    }
    
    CustomTableViewCell *cell = [_tableView cellForRowAtIndexPath:_indexPath];
    cell.delegate = self;
    
    if (timerNotificationCenterItem.isRunTimer) { // label cell đc cập nhật khi chuyển tab view
        cell.rightUtilityButtons = [self rightButtonsTodoPause];
        [self updateLabelForCell];
    } else {
        cell.rightUtilityButtons = [self rightButtonsStatusToDo];
        [self updateLabelForCell];
    }
    
    _settingItem.isChanged = 0;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:0 forKey:keyIsChanged];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRegisterUserNotificationSetting];
    size = [[UIScreen mainScreen] bounds].size;
    _status = false;
    _isUndo = false;
    _indexIsEditing = -1;
    _indexPath = nil;
    _segmentControl.selectedSegmentIndex = 0;
    
    _txtItemTodo = [[UITextField alloc] initWithFrame:CGRectMake(0, size.height, size.width, 40)];
    [self.view addSubview:_txtItemTodo];
    _txtItemTodo.placeholder = @"Adding new task";
    _txtItemTodo.textColor = [UIColor blackColor];
    [_txtItemTodo setBackgroundColor:[UIColor whiteColor]];
    _txtItemTodo.hidden = YES;
    _txtItemTodo.delegate = self;

    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _moneyDBController = [MoneyDBController getInstance];
    
    _searchBar.delegate = self;
    
    heightTableview = _tableView.bounds.size.height;
    widthTableview = _tableView.bounds.size.width;
    
    _showEditBtn = self.navigationItem.rightBarButtonItem;
    [self loadData];
    [self registerForKeyboardNotification];
    
    totalTodos = _arrTodos.count;
    //[_segmentControl setTitle:[NSString stringWithFormat:@"To Do (%lu)",totalTodos] forSegmentAtIndex:0];
    
    //gọi hàm chạy bắt đầu chạy timer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLabelForCell:)
                                                 name:keyStartTimer
                                               object:nil];
    isStartting = true;
}

#pragma mark register user notification setting

- (void) setupRegisterUserNotificationSetting{
    
    UIMutableUserNotificationAction *notificationAction1 = [[UIMutableUserNotificationAction alloc] init];
    notificationAction1.identifier = @"Accept";
    notificationAction1.title = @"Accept";
    notificationAction1.activationMode = UIUserNotificationActivationModeBackground;
    notificationAction1.destructive = NO;
    notificationAction1.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *notificationAction2 = [[UIMutableUserNotificationAction alloc] init];
    notificationAction2.identifier = @"Reject";
    notificationAction2.title = @"Reject";
    notificationAction2.activationMode = UIUserNotificationActivationModeBackground;
    notificationAction2.destructive = YES;
    notificationAction2.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *notificationAction3 = [[UIMutableUserNotificationAction alloc] init];
    notificationAction3.identifier = @"Reply";
    notificationAction3.title = @"Reply";
    notificationAction3.activationMode = UIUserNotificationActivationModeForeground;
    notificationAction3.destructive = NO;
    notificationAction3.authenticationRequired = YES;
    
    UIMutableUserNotificationCategory *notificationCategory = [[UIMutableUserNotificationCategory alloc] init];
    notificationCategory.identifier = @"Email";
    [notificationCategory setActions:@[notificationAction1,notificationAction2,notificationAction3] forContext:UIUserNotificationActionContextDefault];
    [notificationCategory setActions:@[notificationAction1,notificationAction2] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:notificationCategory, nil];
    
    UIUserNotificationType notificationType = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationType categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

#pragma mark load data from database
- (void) loadData {

    NSString *stringID = [NSString stringWithFormat:@"%ld",_settingItem.projectID];
    NSArray *arr = [[NSArray alloc] initWithObjects:stringID, nil];
    if (_segmentControl.selectedSegmentIndex == 0) {
        
        _arrTodos = [GetToDoItemIsDoingToDatabase getTodoItemToDatabase:_moneyDBController where:arr];
        
        _arrTodosRe_Oder = [GetToDoItemIsDoingToDatabase getTodoItemToDatabase:_moneyDBController where:arr];
        [self.tableView reloadData];
    } else {
        NSMutableArray *arrTodoItemDateCompleteds;
        
        GetTodoItemWasDoneOrderByDateCompletedTask *getTodoItemOrderByDateCompleted = [[GetTodoItemWasDoneOrderByDateCompletedTask alloc] init];
        arrTodoItemDateCompleteds = [getTodoItemOrderByDateCompleted getTodoItemToDatbase:_moneyDBController where:arr];
        
        if (arrTodoItemDateCompleteds.count != 0) {
            
            _arrTitleSections = [[NSMutableArray alloc] init];
            TodoItem *todoItem = [[TodoItem alloc] init];
            todoItem = [arrTodoItemDateCompleteds objectAtIndex:0];
            
            NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
            [dateFomatter setDateFormat:@"yyyy - MM - dd"];
            
            NSString *dateCmp = [dateFomatter stringFromDate:todoItem.dateCompleted];
            [_arrTitleSections addObject:dateCmp];
            
            DebugLog(@"DateFomatter: %@", dateCmp);
            for (int i = 0; i < arrTodoItemDateCompleteds.count; i++) {
                
                TodoItem *todoItemCompare = [arrTodoItemDateCompleteds objectAtIndex:i];
                NSString *dateTodoItemCompare = [dateFomatter stringFromDate:todoItemCompare.dateCompleted];
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
                for (int j = 0; j < arrTodoItemDateCompleteds.count; j ++) {
                    
                    TodoItem *todoItemDict = [[TodoItem alloc] init];
                    todoItemDict = [arrTodoItemDateCompleteds objectAtIndex:j];
                    NSString *dateString = [dateFomatter stringFromDate: todoItemDict.dateCompleted];
                    if ([keyDate isEqual:dateString]) {
                        
                        [arrTodoItems addObject:todoItemDict];
                    }
                }
                [todoItemDictionarys setObject:arrTodoItems forKey:keyDate];
            }
            _todoItemDictionarys = todoItemDictionarys;
            [self.tableView reloadData];
        } else {
            _arrTitleSections = [[NSMutableArray alloc] init];
            [self.tableView reloadData];
        }
        
    }
}


#pragma mark implement IBAC


- (IBAction)editOnClicked:(id)sender {
    
    if (![self.tableView isEditing]) {
        
        [_tableView setEditing:YES animated:YES];
        _tableView.allowsSelectionDuringEditing= YES;
        [_editButton setTitle:@"Close"];
    } else {
        [_tableView setEditing:NO animated:YES];
        [_editButton setTitle:@"Edit"];
        if (_segmentControl.selectedSegmentIndex == 0) {
            if (_sourceIndexOfRow < _destinationIndexPathOfRow) {
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
                for (NSInteger i = _destinationIndexPathOfRow; i <= _sourceIndexOfRow; i++) {
                    TodoItem *todoItem = [[TodoItem alloc] init];
                    todoItem = [_arrTodos objectAtIndex:i];
                    
                    TodoItem *todosItemReOder = [[TodoItem alloc] init];
                    todosItemReOder = [_arrTodosRe_Oder objectAtIndex:i];
                    todosItemReOder.content = todoItem.content;
                    todosItemReOder.status = todoItem.status;
                    
                    UpdateToDoItemToDatabase *updateTodoItemTask = [[UpdateToDoItemToDatabase alloc]initWithTodoItem:todosItemReOder];
                    [updateTodoItemTask doQuery:_moneyDBController];
                }
            }
        }
    }
        
}

- (IBAction)segrumentOnClicked:(id)sender {
    
    switch (_segmentControl.selectedSegmentIndex) {
        case 0:
            
            self.navigationItem.rightBarButtonItem = _showEditBtn;
            _status = false;
            [self loadData];
            break;
            
        case 1:
            
            self.navigationItem.rightBarButtonItem = nil;
            [self.tableView setEditing:NO animated:YES];
            _status = true;
            [_txtItemTodo resignFirstResponder];
            [self loadData];
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }
}

- (IBAction)addItem:(id)sender {
    
    _indexIsEditing = -1;
    _status = false;
    _segmentControl.selectedSegmentIndex = 0;
    self.navigationItem.rightBarButtonItem = _showEditBtn;
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
    
    //[_tableView reloadData];
    [UIView animateWithDuration:animationDuration animations:^{
        
        if (_indexIsEditing == -1) {
            
            self.keyboardContraint.constant = height - 40;
            //[_tableView layoutIfNeeded];
            _txtItemTodo.frame = CGRectMake(6, size.height - height - 40, keyboardFrame.size.width - 8, 40);
            _txtItemTodo.hidden = NO;
            
        } else {
            self.keyboardContraint.constant = height;
            _txtItemTodo.frame = CGRectMake(6, size.height - height, keyboardFrame.size.width - 8, 40);
            _txtItemTodo.hidden = NO;
            [_txtItemTodo setBackgroundColor:[UIColor whiteColor]];
        }
    } completion:^(BOOL finished) {
    
        if (_arrTodos.count > 0) {
            
            if (_indexIsEditing == -1) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_arrTodos.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            } else {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
    }];
}

- (void) keyboardWillBeHidden: (NSNotification *) aNotification {
    
    NSDictionary *info = [aNotification userInfo];
//    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    CGRect keyboardFrame = [kbFrame CGRectValue];
//    CGFloat height = keyboardFrame.size.height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.keyboardContraint.constant = 0;
        [self.tableView setNeedsLayout];
        _txtItemTodo.frame = CGRectMake(4, self.view.bounds.size.height, self.view.bounds.size.width - 8, 40);
        _txtItemTodo.hidden = YES;
    }  completion:^(BOOL finished) {
        [self loadData];
    }];
}

#pragma  mark TextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if (_indexIsEditing == -1) {
        
        if ([_txtItemTodo.text isEqual:@""]) {
            
            _txtItemTodo.hidden = YES;
            [_txtItemTodo resignFirstResponder];
            
        } else {
            totalTodos ++;
            [_segmentControl setTitle:[NSString stringWithFormat:@"To Do (%ld)", (long)totalTodos] forSegmentAtIndex:0];
            _txtItemTodo.hidden = YES;
            _todoItem = [[TodoItem alloc] init];
            _todoItem.content = _txtItemTodo.text;
            _todoItem.projectID = _settingItem.projectID;
            
            [_moneyDBController insert:@"todos" data:[DBUtil ToDoItemToDBItem:_todoItem ]];
            
            [self loadData];
            [_txtItemTodo resignFirstResponder];
            _txtItemTodo.text = @"";
        }

    }else if(_indexIsEditing == 0){
        
        NSIndexPath *indexPathSelected = [NSIndexPath indexPathForRow:_indexPath.row inSection:0];
        CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathSelected];
        
        TodoItem *todoItemEdit = [[TodoItem alloc] init];
        todoItemEdit = [_arrTodos objectAtIndex:_indexPath.row];
        todoItemEdit.content = cell.txtTask.text;
        
        UpdateToDoItemToDatabase *updateTodoItemDatabase = [[UpdateToDoItemToDatabase alloc] initWithTodoItem:todoItemEdit];
        [updateTodoItemDatabase doQuery:_moneyDBController];
        [self.tableView reloadData];
        
        DebugLog(@"tetxTask: %@",cell.txtTask.text);
    }
        [self loadData];
    
    return YES;
}

#pragma mark table view

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (_segmentControl.selectedSegmentIndex == 1) {
        
        return _arrTitleSections.count;
    }
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_segmentControl.selectedSegmentIndex == 1) {
        
        NSString *titleSection = [_arrTitleSections objectAtIndex:section];
        NSArray *arrRows = [_todoItemDictionarys objectForKey:titleSection];
        return arrRows.count;
        //return 1;
    }
    
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
        
        cell.leftUtilityButtons = [self leftButtonsStatusToDo];
        cell.rightUtilityButtons = [self rightButtonsStatusToDo];
    } else {
        
        cell.leftUtilityButtons = [self leftButtonsStatusDone];
        cell.rightUtilityButtons = [self rightButtonsStatusDone];
    }
    
    cell.delegate = self;
    cell.txtTask.enabled = NO;
    cell.txtTask.delegate = self;
    
    if (_segmentControl.selectedSegmentIndex == 0) {
        TodoItem *todoItem = [[TodoItem alloc] init];
        todoItem = [_arrTodos objectAtIndex:indexPath.row];
        cell.txtTask.text = todoItem.content;
    } else if (_segmentControl.selectedSegmentIndex == 1){
        
        DebugLog(@"segument: %ld", _segmentControl.selectedSegmentIndex);
        NSString *titleSection = [_arrTitleSections objectAtIndex:indexPath.section];
        
        DebugLog(@"section: %ld",(long)indexPath.section);
        TodoItem *todoItemDict = [[TodoItem alloc] init];
        NSArray *arrTodoItem = [_todoItemDictionarys objectForKey:titleSection];
        todoItemDict = [arrTodoItem objectAtIndex:indexPath.row];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSString *todoItemTimeCompleted = [dateFormatter stringFromDate:todoItemDict.dateCompleted];
        cell.labelTime.text = todoItemTimeCompleted;
        cell.txtTask.text = todoItemDict.content;
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_segmentControl.selectedSegmentIndex == 1) {
        
        return 50;
    }
    return 45;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_segmentControl.selectedSegmentIndex == 1) {
        
        return [_arrTitleSections objectAtIndex:section];
    }
    return @"";
}
- (NSArray *) rightButtonsTodoPause {
    NSMutableArray *rightUtilitylButtons = [[NSMutableArray alloc] init];
    
    [rightUtilitylButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0] title:@"Delete"];
    
    [rightUtilitylButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.16f green:0.36f blue:0.82f alpha:1.0] title:@"Edit"];
    [rightUtilitylButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:11.0f/255.0f green:150.0f/255.0f blue:243.0f/255.0f alpha:1.0f]  title:@"Pause"];
    
    return rightUtilitylButtons;
}
- (NSArray *) rightButtonsStatusToDo {
    
    NSMutableArray *rightUtilitylButtons = [[NSMutableArray alloc] init];
    
    [rightUtilitylButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0] title:@"Delete"];
    
    [rightUtilitylButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.16f green:0.36f blue:0.82f alpha:1.0] title:@"Edit"];
    [rightUtilitylButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:11.0f/255.0f green:150.0f/255.0f blue:243.0f/255.0f alpha:1.0f]  title:@"Start"];
    
    return rightUtilitylButtons;
}

- (NSArray *) rightButtonsStatusDone {
    
    NSMutableArray *rightUtilitylButtons = [[NSMutableArray alloc] init];
    
    [rightUtilitylButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0] title:@"Delete"];
    
    //[rightUtilitylButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.16f green:0.36f blue:0.82f alpha:1.0] title:@"Edit"];
    
    return rightUtilitylButtons;
}
- (NSArray *) leftButtonsStatusToDo {
    
        NSMutableArray *leftUtilityButtons = [[NSMutableArray alloc] init];
        
        [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.07f green:0.75f blue:0.16f alpha:1.0] title:@"Done"];
    
    return leftUtilityButtons;
}

- (NSArray *) leftButtonsStatusDone {
    
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
        //done
            DebugLog(@"you press button done");
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        if (_segmentControl.selectedSegmentIndex == 0) {
            
            totalTodos --;
            if (totalTodos > 0) {
                [_segmentControl setTitle:[NSString stringWithFormat:@"To Do (%ld)", (long)totalTodos] forSegmentAtIndex:0];
            } else {
                [_segmentControl setTitle:[NSString stringWithFormat:@"To Do"] forSegmentAtIndex:0];
            }
            
            
            TodoItem *todoItem = _arrTodos [indexPath.row];
            todoItem.status = true;
            todoItem.dateCompleted = [NSDate date];
            
            UpdateToDoItemToDatabase *updateTodoItemTask = [[UpdateToDoItemToDatabase alloc]initWithTodoItem:todoItem];
            [updateTodoItemTask doQuery:_moneyDBController];
        
            DebugLog(@"update was accessesfully");
            [self.arrTodos removeObject:todoItem];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView reloadData];
            
        } else {
            // Undone
            totalTodos ++;
            [_segmentControl setTitle:[NSString stringWithFormat:@"To Do (%ld)", (long)totalTodos] forSegmentAtIndex:0];
            NSString *keyDate = [_arrTitleSections objectAtIndex:indexPath.section];
            NSMutableArray *arrTodoItems = [_todoItemDictionarys objectForKey:keyDate];
            TodoItem *todoItem = [[TodoItem alloc] init];
            todoItem = [arrTodoItems objectAtIndex:indexPath.row];
            todoItem.status = false;
            
            UpdateToDoItemToDatabase *updateTodoItemTask = [[UpdateToDoItemToDatabase alloc]initWithTodoItem:todoItem];
            [updateTodoItemTask doQuery:_moneyDBController];
            
            DebugLog(@"update was accessesfully");
            
            [arrTodoItems removeObjectAtIndex:indexPath.row];
            [_todoItemDictionarys setObject:arrTodoItems forKey:keyDate];
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            [self.tableView reloadData];
            [self loadData];
        }
    }
}

- (void) swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    // index = 0 button is delete
     NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    _indexPathRow = indexPath.row;
    if (index == 0) {
        if (_segmentControl.selectedSegmentIndex == 0) {
            
            totalTodos --;
            if (totalTodos > 0) {
                [_segmentControl setTitle:[NSString stringWithFormat:@"To Do (%ld)", (long)totalTodos] forSegmentAtIndex:0];
            } else {
                [_segmentControl setTitle:[NSString stringWithFormat:@"To Do"] forSegmentAtIndex:0];
            }
            _isUndo = false;
            
            if (_undoView) {
                [self deleteTodoItemToDatabase];
                [_undoView removeFromSuperview];
                [self animateUndoViewDisplay];
            } else {
                
                [self animateUndoViewDisplay];
            }
            
            TodoItem *todoItemRemoveFromTable = [_arrTodos objectAtIndex:indexPath.row];
            _todoItemUndo = todoItemRemoveFromTable;
            
            [self.arrTodos removeObject:todoItemRemoveFromTable];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView reloadData];
            
            
            [self performSelector:@selector(deleteRowFromTableview) withObject:self afterDelay:3];
        } else if (_segmentControl.selectedSegmentIndex == 1){
            
            if (_undoView) {
                
                [self deleteTodoItemToDatabase];
                [_undoView removeFromSuperview];
                [self animateUndoViewDisplay];
            } else {
                
                [self animateUndoViewDisplay];
            }
            NSString *keyDate = [_arrTitleSections objectAtIndex:indexPath.section];
            NSMutableArray *arrTodoItems = [_todoItemDictionarys objectForKey:keyDate];
            TodoItem *todoItemRemoveFromTable = [arrTodoItems objectAtIndex:indexPath.row];
            _todoItemUndo = todoItemRemoveFromTable;
            
            [arrTodoItems removeObjectAtIndex:indexPath.row];
            [_todoItemDictionarys setObject:arrTodoItems forKey:keyDate];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView reloadData];
            
            [self performSelector:@selector(deleteRowFromTableview) withObject:self afterDelay:3];
        }
        
        DebugLog(@"Press button is delete");
    }
    // index = 1 button is edit
    if (index == 1) {
        
        [_tableView reloadData];
        _indexIsEditing = 0;
        _indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        
        CustomTableViewCell *cellSelected = [_tableView cellForRowAtIndexPath:_indexPath];
        
        cellSelected.txtTask.enabled = YES;
        [cellSelected.txtTask becomeFirstResponder];
    }
    // index = 2 button is start
    if (index == 2) {
        [self.tableView reloadData];
        _indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        SettingItem *settingItem = [SettingItem new];
        settingItem = appDelegate.settingItem;
        
        TodoItem *todoItem = [TodoItem new];
        todoItem = [_arrTodos objectAtIndex:_indexPath.row];
        DebugLog(@"_indexPath: %@", _indexPath);
        if (_indexPath.row != settingItem.indexPathForCell) { // so sách index path đang chạy timer vs index path vừa ấn có giống nhau hay không.. nếu không giống nhau thì chạy lại timer từ đâu
           
            timerNotificationCenterItem.isRunTimer = true; // cài lại toàn bộ các giá trị liên quan đến timer
            [timerNotificationCenterItem.timer invalidate];
            timerNotificationCenterItem.timer = nil;
            timerNotificationCenterItem.totalTime = settingItem.timeWork * 60;
            timerNotificationCenterItem.timeMinutes = settingItem.timeWork;
            timerNotificationCenterItem.timeSeconds = 0;
            timerNotificationCenterItem.stringStatusWorking = @"Working";
            timerNotificationCenterItem.isWorking = true;
            timerNotificationCenterItem.totalWorking = 0;
            timerNotificationCenterItem.totalLongBreaking = 0;
            timerNotificationCenterItem.stringTaskname = todoItem.content;
            
            [userDefaults setInteger:_indexPath.row forKey:keyIndexPathForCell];
            settingItem.indexPathForCell = (int)_indexPath.row;
            
            [userDefaults setInteger:1 forKey:keyisActive];
            settingItem.isActive = 1;
            
            [userDefaults setInteger:0 forKey:keyIsChanged];
            settingItem.isChanged = 0;

            self.tabBarController.selectedIndex = 1;
            
        } else {
            
            if (!isStartting) {
                timerNotificationCenterItem.isRunTimer = isStartting; // gán giá trị isRunTimer = false
                [self updateLabelForCell];
                [appDelegate startStopTimer];
                isStartting = true;
                
            } else if (isStartting){
                
                timerNotificationCenterItem.isRunTimer = isStartting; // gán giá trị isRunTimer = true
                timerNotificationCenterItem.stringTaskname = todoItem.content;
                [userDefaults setInteger:1 forKey:keyisActive];
                settingItem.isActive = 1;
                self.tabBarController.selectedIndex = 1;
                isStartting = false;
            }
        }
    }
}
#pragma mark NSTimer
- (void) updateLabelForCell {  // khi timer invalidate thì label cell đc cập nhật lại cho đúng với thời gian timer dừng
    CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    cell.labelTime.text = [NSString stringWithFormat:@"%@ %@ ", timerNotificationCenterItem.stringStatusWorking,[self setTextLabelForCell:timerNotificationCenterItem.timeMinutes and: timerNotificationCenterItem.timeSeconds]];
}
- (void) updateLabelForCell: (NSNotification *) notification { // label cell đc cập nhật liên tục khi timer running     
    CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    cell.labelTime.text = [NSString stringWithFormat:@"%@ %@ ", timerNotificationCenterItem.stringStatusWorking,[self setTextLabelForCell: timerNotificationCenterItem.timeMinutes and: timerNotificationCenterItem.timeSeconds]];
    if (timerNotificationCenterItem.timeMinutes == 0 && timerNotificationCenterItem.timeSeconds == 0) {
        DebugLog(@"____________%@", timerNotificationCenterItem.stringStatusWorking);
        if ([timerNotificationCenterItem.stringStatusWorking isEqualToString:@"Breaking"]) {
            [self pushNoteView:@"This is time to break"];
        } else if ([timerNotificationCenterItem.stringStatusWorking isEqualToString:@"Working"]) {
            [self pushNoteView:@"This is time to work"];
        } else if ([timerNotificationCenterItem.stringStatusWorking isEqualToString:@"Long Breaking"]) {
            [self pushNoteView:@"This is time to long break"];
        }
        [self playSound];
        [self performSelector:@selector(removePushView) withObject:nil afterDelay:3];
    }
}

#pragma mark push and remove note view

- (void) playSound {
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"chuongtit" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:soundFile];
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    
}
- (void) removePushView {
    [AGPushNoteView close];
}

- (void) pushNoteView: (NSString *) stringNotePush {
    
    [AGPushNoteView showWithNotificationMessage:stringNotePush];
    [AGPushNoteView setMessageAction:^(NSString *message) {
        [AGPushNoteView showWithNotificationMessage:message completion:^{}];
    }];
}
#pragma mark set Text Label For Cell

- (NSString *) setTextLabelForCell: (int) minutes and: (int) seconds {
    NSString *stringMinutes;
    if (timerNotificationCenterItem.timeMinutes >= 10) {
        stringMinutes = [NSString stringWithFormat:@"%d", timerNotificationCenterItem.timeMinutes];
    } else {
        stringMinutes = [NSString stringWithFormat:@"0%d", timerNotificationCenterItem.timeMinutes];
    }
    NSString *stringSeconds;
    if (timerNotificationCenterItem.timeSeconds >= 10) {
        stringSeconds = [NSString stringWithFormat:@"%d", timerNotificationCenterItem.timeSeconds];
    } else {
        stringSeconds = [NSString stringWithFormat:@"0%d", timerNotificationCenterItem.timeSeconds];
    }
    
    return [NSString stringWithFormat:@"%@ : %@", stringMinutes, stringSeconds];
}
#pragma mark UndoDelegate

- (void) undoHandle {
    
    _isUndo = true;
    DebugLog(@"Undo is press");
    if (_segmentControl.selectedSegmentIndex == 0) {
        totalTodos ++;
        [_segmentControl setTitle:[NSString stringWithFormat:@"To Do (%ld)", (long)totalTodos] forSegmentAtIndex:0];
        [_arrTodos insertObject:_todoItemUndo atIndex:_indexPathRow];
        [self.tableView reloadData];
        [self animateUndoViewWillBeHidden];
    } else {
        
        [self loadData];
        [self animateUndoViewWillBeHidden];
    }
    
}

#pragma mark delete row tableview

- (void) deleteRowFromTableview  {
    
    if (_isUndo == false) {
        _todoItemUndo.isDelete = true;
        _todoItemUndo.dateDeleted = [NSDate date];
        
        UpdateToDoItemToDatabase *updateTodoItemToDatabaseTask = [[UpdateToDoItemToDatabase alloc] initWithTodoItem:_todoItemUndo];
        [updateTodoItemToDatabaseTask doQuery:_moneyDBController];
        
        DebugLog(@"deleted todoItem mat roi");
        [self animateUndoViewWillBeHidden];
    }
}

- (void) deleteTodoItemToDatabase {
    
    if (_isUndo == false) {
        _todoItemUndo.isDelete = true;
        _todoItemUndo.dateDeleted = [NSDate date];
        
        UpdateToDoItemToDatabase *updateTodoItemToDatabaseTask = [[UpdateToDoItemToDatabase alloc] initWithTodoItem:_todoItemUndo];
        [updateTodoItemToDatabaseTask doQuery:_moneyDBController];
        
        DebugLog(@"deleted todoItem mat roi");
    }

}
#pragma mark init UndoView and animate

- (void) animateUndoViewDisplay {
    
    _undoView = [[UndoView alloc] initWithFrame:CGRectMake(0, 0, size.width * 2 / 3, 30)];
    _undoView.delegate = self;
    _undoView.center = CGPointMake(self.view.bounds.size.width / 3 + 10, size.height + 10);
    _undoView.layer.cornerRadius = 3;
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeLeft:)];
    swipeLeft.delegate = self;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft ;
    [_undoView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeRight:)];
    swipeRight.delegate = self;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight ;
    [_undoView addGestureRecognizer:swipeRight];
    
    [self.view addSubview:_undoView];
    [UIView animateWithDuration:0.3 animations:^{
        
        _undoView.center = CGPointMake(size.width / 3 + 10, size.height - _undoView.bounds.size.height * 3);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _undoView.center = CGPointMake(size.width / 3 + 10, size.height - _undoView.bounds.size.height * 2 - 10);
            
        } completion:nil];}];
}

- (void) animateUndoViewWillBeHidden {
    
    [UIView animateWithDuration:0.2 animations:^{
        _undoView.center = CGPointMake(size.width / 3 + 10, size.height + 10);
    } completion:^(BOOL finished) {
        [_undoView removeFromSuperview];
    }];
}

#pragma mark Event Swip UndoView
- (void) onSwipeLeft: (UISwipeGestureRecognizer *) swipe {
    DebugLog(@"%ld ",swipe.direction);
    [self deleteTodoItemToDatabase];
    [UIView animateWithDuration:0.5 animations:^{
        _undoView.center = CGPointMake(-_undoView.bounds.size.width , size.height - _undoView.bounds.size.height * 2 - 10);
    } completion:^(BOOL finished) {
        [_undoView removeFromSuperview];
    }];
}
- (void) onSwipeRight: (UISwipeGestureRecognizer *) swipe {
    
    [self deleteTodoItemToDatabase];
    [UIView animateWithDuration:0.5 animations:^{
        _undoView.center = CGPointMake(size.width + _undoView.bounds.size.width, size.height - _undoView.bounds.size.height * 2 - 10);
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
