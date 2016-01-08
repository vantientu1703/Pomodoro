//
//  ViewController.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "MainScreen.h"
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
#import "EditableTableController.h"
#import "MenuProjectManageTableViewController.h"
#import "GetProjectManageItemToDatabaseTask.h"
#import "MenuAnimation.h"
#import "ResultsSearchTodoItemTableViewController.h"
#import "GetAllTodoItemsToDatabaseTask.h"
#import "GetTodoItemsFollowPriorityToDatabaseTask.h"
#import "PriorityView.h"
#import "AlarmViewController.h"

#define CELL_HEIGHT 50

static NSString *cellIdentifer = @"cellIdentifer";
@interface MainScreen () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SWTableViewCellDelegate,UndoViewDelegate,UIGestureRecognizerDelegate, EditableTableControllerDelegate, MenuAnimationDelegate,PriorityViewDelegate>

@property (nonatomic, strong) MoneyDBController *moneyDBController;
@property (nonatomic, strong) TodoItem *todoItem;
@property (nonatomic, strong) UndoView *undoView;
@property (nonatomic, strong) EditableTableController *editableTableController;
@property (nonatomic, strong) TodoItem *todoItemBeingMove;
@property (nonatomic, strong) TodoItem *todoItemReplaceholder;
@property (nonatomic, strong) MenuProjectManageTableViewController *menuProjectManageTableViewController;
@property (nonatomic, strong) MenuAnimation *menuAnimation;
@property (nonatomic, strong) PriorityView *priorityView;

@property (nonatomic, strong) NSMutableArray *arrProjectManageItems;
@property (nonatomic, strong) NSMutableArray *arrTitleSections;
@property (nonatomic, strong) NSMutableArray *arrTodosRe_Oder;
@property (nonatomic, strong) NSMutableArray *arrTodos;
@property (nonatomic, strong) NSMutableArray *arrFilteredTodos;
@property (nonatomic, strong) NSMutableArray *arrTodoItemWasDone;
@property (nonatomic, strong) NSMutableArray *arrAllTodoItems;
@property (nonatomic, strong) NSMutableArray *arrTodoItemsFollowPriorityAllSection;
@property (nonatomic, strong) NSUserDefaults *shareUserDefaults;

@property (nonatomic, assign) BOOL status;
@property (nonatomic, assign) NSInteger indexPathRow;
@property (nonatomic, assign) CGFloat heightKeyboard;
@end

@implementation MainScreen
{
    
    TodoItem *_todoItemUndo;
    AppDelegate *appDelegate;
    TimerNotificationcenterItem *timerNotificationCenterItem;
    SettingItem *_settingItem;
    
    int heightTableview, widthTableview;
    int priority;
    int _indexIsEditing;
    
    BOOL _isUndo;
    BOOL isStartting;
    BOOL isShowMenu;
    BOOL isFiltered;
    BOOL isSearching;
    BOOL isSelectSegmentControl;
    BOOL isPriority;
    
    NSInteger totalTodos;
    NSInteger _sourceIndexOfRow, _destinationIndexPathOfRow;
    NSIndexPath *_indexPath;
    NSIndexPath *_toIndexPath;
    
    NSString *_projectName;
    NSString *statusUseKeyboard;
    NSString *stringSearching;
    NSString *_contentTextTask;
    
    NSMutableDictionary *_todoItemDictionarys;
    NSMutableArray *_arrTodoItemsPriorityHight, *_arrTodoItemsPriorityMedium, *_arrTodoItemsPriorityLow, *_arrTodoItemsNoPriority;
    
    UIBarButtonItem *_showEditBtn;
    UIButton *doneOrCancelBtn;
    
    CGSize size;
    
    AVAudioPlayer *audioPlayer;
    
    UIView *viewGrayBackground;
    UIView *viewHeader;
    
    UISegmentedControl *segmentController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    size = [[UIScreen mainScreen] bounds].size;
    isPriority = true;
    _tableView.delegate = self;
    _tableView.dataSource = self;

    _shareUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
    appDelegate = [[UIApplication sharedApplication] delegate];
    timerNotificationCenterItem = appDelegate.timerNotificationcenterItem;
    _settingItem = appDelegate.settingItem;
    [self startupApp];
    [self loadData];
    
    if ([[_shareUserDefaults stringForKey:@"key_timer_running"] isEqualToString:@"running"]) {
        self.tabBarController.selectedIndex = 1;
    }
    _settingItem.isChanged = 0;
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
    [userDefaults setInteger:0 forKey:KEY_IS_CHANGED];
    
    [self setupEditTableView];
    [self removeMenuAndViewGrayBackground];
    [self.tableView reloadData];
    
    CustomTableViewCell *cell = [_tableView cellForRowAtIndexPath:_indexPath];
    cell.delegate = self;
    
    NSString *stringTimerRunning;
    stringTimerRunning = [_shareUserDefaults stringForKey:@"key_timer_running"];
    if ([stringTimerRunning isEqualToString:@"stop_containing_app"] || [stringTimerRunning isEqualToString:@"stop"]) {
        timerNotificationCenterItem.isRunTimer = false;
        [_shareUserDefaults setObject:@"" forKey:@"key_timer_running"];
        [self.tableView reloadData];
    } else if ([stringTimerRunning isEqualToString:@"pause"]) {
        [_shareUserDefaults setObject:@"" forKey:@"key_timer_running"];
        timerNotificationCenterItem.isRunTimer = false;
        [appDelegate startStopTimer];
    } else if ([stringTimerRunning isEqualToString:@"start"]) {
        [_shareUserDefaults setObject:@"" forKey:@"key_timer_running"];
        timerNotificationCenterItem.isRunTimer = true;
        [appDelegate startStopTimer];
    }
    
    if (timerNotificationCenterItem.isRunTimer) {
        // label cell đc cập nhật khi chuyển tab view
        isStartting = false;
        cell.rightUtilityButtons = [self rightButtonsTodoPause];
        [self updateLabelForCell];
    } else {
        isStartting = true;
        cell.rightUtilityButtons = [self rightButtonsStatusToDo];
        [self updateLabelForCell];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushTabbarViewControllerIndex2) name:@"appDidBecomeActive"
                                               object:nil];
}

- (void) pushTabbarViewControllerIndex2 {
    self.tabBarController.selectedIndex = 1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRegisterUserNotificationSetting];
    size = [[UIScreen mainScreen] bounds].size;
    
    isShowMenu = true;
    _status = false;
    _isUndo = false;
    _indexPath = nil;
    _segmentControl.selectedSegmentIndex = 0;
    
    _txtItemTodo = [[UITextField alloc] initWithFrame:CGRectMake(0, size.height, size.width, 40)];
    [self.view addSubview:_txtItemTodo];
    _txtItemTodo.placeholder = @"Adding new task";
    _txtItemTodo.textColor = [UIColor blackColor];
    [_txtItemTodo setBackgroundColor:[UIColor whiteColor]];
    _txtItemTodo.hidden = YES;
    _txtItemTodo.delegate = self;
    _searchBar.delegate = self;
    
    _moneyDBController = [MoneyDBController getInstance];
    
    heightTableview = _tableView.bounds.size.height;
    widthTableview = _tableView.bounds.size.width;
    
    _showEditBtn = self.navigationItem.rightBarButtonItem;
    [self loadData];
    [self.tableView reloadData];
    [self registerForKeyboardNotification];
    
    totalTodos = _arrTodos.count;
    
    //gọi hàm chạy bắt đầu chạy timer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLabelForCell:)
                                                 name:KEY_START_TIMER
                                               object:nil];
    isStartting = true;
}

#pragma mark - startup app 

- (void) startupApp {
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
    if (!_settingItem.isStartupApp) {
        _settingItem.isStartupApp = true;
        [userDefaults setBool:true forKey:KEY_START_APP];
        
        _settingItem.projectName = @"Book Story";
        NSArray *arr = [[NSArray alloc] initWithObjects:@"Book Story", nil];
        [userDefaults setObject:arr forKey:KEY_PROCJECT_NAME];
        
        _settingItem.projectID = 2;
        [userDefaults setInteger:2 forKey:KEY_PROJECT_ID];
        
        TodoItem *todoItem = [[TodoItem alloc] init];
        ProjectManageItem *projectManageItem = [[ProjectManageItem alloc] init];
        
        projectManageItem.projectName = @"New Project";
        projectManageItem.startDate = [NSDate date];
        [_moneyDBController insert:PROJECTMANAGE data:[DBUtil projectManageItemToDBItem:projectManageItem]];
        
        todoItem.content = @"What do you do ?";
        todoItem.projectID = 1;
        [_moneyDBController insert:TODOS data:[DBUtil ToDoItemToDBItem:todoItem]];
        todoItem.content = @"Go to school";
        todoItem.projectID = 1;
        [_moneyDBController insert:TODOS data:[DBUtil ToDoItemToDBItem:todoItem]];
        
        projectManageItem.projectName = @"Book Story";
        projectManageItem.startDate = [NSDate date];
        [_moneyDBController insert:PROJECTMANAGE data:[DBUtil projectManageItemToDBItem:projectManageItem]];
        
        todoItem.content = @"The Learn Startup";
        todoItem.projectID = 2;
        [_moneyDBController insert:TODOS data:[DBUtil ToDoItemToDBItem:todoItem]];
        todoItem.content = @"Inferno";
        todoItem.projectID = 2;
        [_moneyDBController insert:TODOS data:[DBUtil ToDoItemToDBItem:todoItem]];
        todoItem.content = @"Angels and Demons";
        todoItem.projectID = 2;
        [_moneyDBController insert:TODOS data:[DBUtil ToDoItemToDBItem:todoItem]];
        
        projectManageItem.projectName = @"Shopping";
        projectManageItem.startDate = [NSDate date];
        [_moneyDBController insert:PROJECTMANAGE data:[DBUtil projectManageItemToDBItem:projectManageItem]];
        
        todoItem.content = @"Go to AppStore";
        todoItem.projectID = 3;
        [_moneyDBController insert:TODOS data:[DBUtil ToDoItemToDBItem:todoItem]];
        todoItem.content = @"Be going to buy T - short";
        todoItem.projectID = 3;
        [_moneyDBController insert:TODOS data:[DBUtil ToDoItemToDBItem:todoItem]];
        todoItem.content = @"Store Lovely";
        todoItem.projectID = 3;
        [_moneyDBController insert:TODOS data:[DBUtil ToDoItemToDBItem:todoItem]];
    }
}
#pragma mark set Edit tableview

- (void) setupEditTableView {
    
    if (_segmentControl.selectedSegmentIndex == 0) {
        
        [_shareUserDefaults setInteger:4 forKey:@"key_number_sections"];
        self.tableView.estimatedRowHeight = CELL_HEIGHT;
        [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:cellIdentifer];
        self.editableTableController = [[EditableTableController alloc] initWithTableView:self.tableView];
        self.editableTableController.delegate = self;
    } else if (_segmentControl.selectedSegmentIndex == 1) {
        [_shareUserDefaults setInteger:_arrTitleSections.count forKey:@"key_number_sections"];
        self.tableView.estimatedRowHeight = CELL_HEIGHT;
        [self.tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:cellIdentifer];
        self.editableTableController = [[EditableTableController alloc] initWithTableView:self.tableView];
        self.editableTableController.enabled = NO;
        self.editableTableController.delegate = nil;
    }
}
- (void) updateTodoItemToDatabase {
    
    if (_segmentControl.selectedSegmentIndex == 0) {
        if (_sourceIndexOfRow < _destinationIndexPathOfRow) {
            for (NSInteger i = _sourceIndexOfRow; i <= _destinationIndexPathOfRow; i++) {
                TodoItem *todoItem = [[TodoItem alloc] init];
                todoItem = [_arrTodos objectAtIndex:i];
                
                TodoItem *todosItemReOder = [[TodoItem alloc] init];
                todosItemReOder = [_arrTodosRe_Oder objectAtIndex:i];
                todosItemReOder.content = todoItem.content;
                todosItemReOder.status = todoItem.status;
                todosItemReOder.pomodoros = todoItem.pomodoros;
                todosItemReOder.dateDeleted = todoItem.dateDeleted;
                todosItemReOder.dateCompleted = todoItem.dateCompleted;
                todosItemReOder.isDelete = todoItem.isDelete;
                todosItemReOder.projectID = todoItem.projectID;
                
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
                todosItemReOder.pomodoros = todoItem.pomodoros;
                todosItemReOder.dateDeleted = todoItem.dateDeleted;
                todosItemReOder.dateCompleted = todoItem.dateCompleted;
                todosItemReOder.isDelete = todoItem.isDelete;
                todosItemReOder.projectID = todoItem.projectID;
                
                UpdateToDoItemToDatabase *updateTodoItemTask = [[UpdateToDoItemToDatabase alloc]initWithTodoItem:todosItemReOder];
                [updateTodoItemTask doQuery:_moneyDBController];
            }
        }
    }
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
    
    [self loadTodoItemsPriority];
    
    GetProjectManageItemToDatabaseTask *getProjectManageItemToDatabaseTask = [[GetProjectManageItemToDatabaseTask alloc] init];
    _arrProjectManageItems = [getProjectManageItemToDatabaseTask getProjectManageItemToDatabase:_moneyDBController];
    
    GetAllTodoItemsToDatabaseTask *getAllTodoItemsToDatabaseTask = [[GetAllTodoItemsToDatabaseTask alloc] init];
    _arrAllTodoItems = [getAllTodoItemsToDatabaseTask getAllTodoItemsToDatabase:_moneyDBController];
    
    NSString *stringID = [NSString stringWithFormat:@"%ld",_settingItem.projectID];
    NSArray *arr = [[NSArray alloc] initWithObjects:stringID, nil];
    if (_segmentControl.selectedSegmentIndex == 0) {
        
        _arrTodos = [GetToDoItemIsDoingToDatabase getTodoItemToDatabase:_moneyDBController where:arr];
        
        _arrTodosRe_Oder = [GetToDoItemIsDoingToDatabase getTodoItemToDatabase:_moneyDBController where:arr];
    } else {
        NSMutableArray *arrTodoItemDateCompleteds;
        
        GetTodoItemWasDoneOrderByDateCompletedTask *getTodoItemOrderByDateCompleted = [[GetTodoItemWasDoneOrderByDateCompletedTask alloc] init];
        arrTodoItemDateCompleteds = [getTodoItemOrderByDateCompleted getTodoItemToDatbase:_moneyDBController where:arr];
        _arrTodoItemWasDone = [getTodoItemOrderByDateCompleted getTodoItemToDatbase:_moneyDBController where:arr];
        
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
        } else {
            _arrTitleSections = [[NSMutableArray alloc] init];
        }
    }
    totalTodos = _arrTodos.count;
    
    if (totalTodos > 0) {
        [_segmentControl setTitle:[NSString stringWithFormat:@"To Do (%lu)",totalTodos]
                forSegmentAtIndex:0];
    } else {
        [_segmentControl setTitle:[NSString stringWithFormat:@"To Do"] forSegmentAtIndex:0];
    }
}

- (void) loadTodoItemsPriority {
    GetTodoItemsFollowPriorityToDatabaseTask *getTodoItemsFollowPriorityToDatabaseTask = [[GetTodoItemsFollowPriorityToDatabaseTask alloc] init];
    _arrTodoItemsPriorityHight = [getTodoItemsFollowPriorityToDatabaseTask getTodoItemsFollowPriorityToDatabaseTask:_moneyDBController withPriority:@[@"1",[NSString stringWithFormat:@"%ld", _settingItem.projectID]]];
    _arrTodoItemsPriorityMedium = [getTodoItemsFollowPriorityToDatabaseTask getTodoItemsFollowPriorityToDatabaseTask:_moneyDBController withPriority:@[@"2",[NSString stringWithFormat:@"%ld", _settingItem.projectID]]];
    _arrTodoItemsPriorityLow = [getTodoItemsFollowPriorityToDatabaseTask getTodoItemsFollowPriorityToDatabaseTask:_moneyDBController withPriority:@[@"3",[NSString stringWithFormat:@"%ld", _settingItem.projectID]]];
    _arrTodoItemsNoPriority = [getTodoItemsFollowPriorityToDatabaseTask getTodoItemsFollowPriorityToDatabaseTask:_moneyDBController withPriority:@[@"0",[NSString stringWithFormat:@"%ld", _settingItem.projectID]]];
    
    _arrTodoItemsFollowPriorityAllSection = [[NSMutableArray alloc] initWithObjects:_arrTodoItemsPriorityHight,_arrTodoItemsPriorityMedium,_arrTodoItemsPriorityLow,_arrTodoItemsNoPriority, nil];
}

#pragma mark implement IBAC


- (IBAction)segrumentOnClicked:(id)sender {
    
    switch (_segmentControl.selectedSegmentIndex) {
        case 0:
            self.navigationItem.rightBarButtonItem = _showEditBtn;
            _status = false;
            isFiltered = NO;
            self.editableTableController.enabled = YES;
            [self loadData];
            [self.tableView reloadData];
            break;
            
        case 1:
            
            self.navigationItem.rightBarButtonItem = nil;
            [self.tableView setEditing:NO animated:YES];
            isFiltered = NO;
            _status = true;
            [_txtItemTodo resignFirstResponder];
            
            self.editableTableController.delegate = self;
            self.editableTableController.enabled = NO;
            [self loadData];
            [self.tableView reloadData];
            
            break;
            
        default:
            break;
    }
}

- (IBAction)addItem:(id)sender {
    
    statusUseKeyboard = @"adding";
    isFiltered = NO;
    _indexIsEditing = 1;
    _status = false;
    _segmentControl.selectedSegmentIndex = 0;
    isSearching = false;
    self.navigationItem.rightBarButtonItem = _showEditBtn;
    [self loadData];
    [self.tableView reloadData];
    if (_indexIsEditing == 1) {
        
        [_txtItemTodo becomeFirstResponder];
    }
}


- (IBAction)menuOnClicked:(id)sender {

    [self showMenu];
}

#pragma mark MenuAnimationDelegate

- (void) closeMenuAnimation {
    
    [self removeMenuAndViewGrayBackground];
    [self loadData];
   
    [self.tableView reloadData];
}

#pragma mark - gray background 

- (void) showMenu {
    
    if (isShowMenu) {
        isShowMenu = false;
        CGFloat statusHeightNavigationBar = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.bounds.size.height;
        
        viewGrayBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        viewGrayBackground.backgroundColor = [UIColor grayColor];
        viewGrayBackground.alpha = 0.0f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(removeMenuAndViewGrayBackground:)];
        tap.cancelsTouchesInView = NO;
        [viewGrayBackground addGestureRecognizer:tap];

        [self.view addSubview:viewGrayBackground];
        
        CGFloat heightTableView = 0.0;
        
        
        if (_arrProjectManageItems.count > 5 || _arrProjectManageItems.count == 0) {
            
            heightTableView = 40 * 5;
            
        } else if (_arrProjectManageItems.count < 5 || _arrProjectManageItems.count > 0 ) {
            
            heightTableView = _arrProjectManageItems.count * 40;
        }
        
        _menuAnimation = [[MenuAnimation alloc] initWithFrame:CGRectMake(0, -heightTableView + statusHeightNavigationBar, size.width, heightTableView)];
        _menuAnimation.delegate = self;
        [self.view addSubview:_menuAnimation];
        
        [UIView animateWithDuration:0.5 animations:^{
            _menuAnimation.frame = CGRectMake(0, statusHeightNavigationBar, _menuAnimation.frame.size.width, _menuAnimation.frame.size.height);
            viewGrayBackground.alpha = 0.7f;
            viewGrayBackground.frame = CGRectMake(0, 0, viewGrayBackground.frame.size.width, viewGrayBackground.frame.size.height);
            
        } completion:^(BOOL finished) {
        }];

    } else {
        [self removeMenuAndViewGrayBackground];
    }
}

- (void) removeMenuAndViewGrayBackground {
    
    [UIView animateWithDuration:0.5 animations:^{
        _menuAnimation.frame = CGRectMake(0, -size.height / 2, size.width, _menuAnimation.frame.size.height);
        viewGrayBackground.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        isShowMenu = true;
        [viewGrayBackground removeFromSuperview];
    }];
}

- (void) removeMenuAndViewGrayBackground: (UITapGestureRecognizer *) tap {
    
    [UIView animateWithDuration:0.5 animations:^{
        _menuAnimation.frame = CGRectMake(0, -size.height / 2, size.width, size.height * 2 / 3);
        viewGrayBackground.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        isShowMenu = true;
        [viewGrayBackground removeFromSuperview];
    }];
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

    if (isPriority) {
        _priorityView = [[PriorityView alloc] initWithFrame:CGRectMake(0, size.height, size.width, 20)];
        [self.view addSubview:_priorityView];
    }
    _priorityView.delegate = self;
    [UIView animateWithDuration:animationDuration animations:^{
            if (_indexIsEditing == 1) {
                self.keyboardContraint.constant = height - 40;
                _txtItemTodo.frame = CGRectMake(6, size.height - height - 40, keyboardFrame.size.width - 8, 40);
                _txtItemTodo.hidden = NO;
                _priorityView.frame = CGRectMake(0, size.height - height - 70, size.width, 20);
                
            } else if (_indexIsEditing == 2) {
                self.keyboardContraint.constant = height - 50;
                _txtItemTodo.hidden = YES;
                [_txtItemTodo setBackgroundColor:[UIColor whiteColor]];
            } else {
                _txtItemTodo.hidden = YES;
                _searchBar.frame = CGRectMake(_searchBar.frame.origin.x, _searchBar.frame.origin.y,size.width - 70, _searchBar.frame.size.height);
                doneOrCancelBtn.frame = CGRectMake(_searchBar.frame.size.width, 0, 70, 40);
            }
        
    } completion:^(BOOL finished) {
        
        if (_indexIsEditing == 1) {
            NSArray *arrTodoItemsPriorityHight;
            NSArray *arrTodoItemsPriorityMedium;
            NSArray *arrTodoItemsPriorityLow;
            NSArray *arrTodoItemsNoPriority;
            arrTodoItemsPriorityHight = [_arrTodoItemsFollowPriorityAllSection objectAtIndex:0];
            arrTodoItemsPriorityMedium = [_arrTodoItemsFollowPriorityAllSection objectAtIndex:1];
            arrTodoItemsPriorityLow = [_arrTodoItemsFollowPriorityAllSection objectAtIndex:2];
            arrTodoItemsNoPriority = [_arrTodoItemsFollowPriorityAllSection objectAtIndex:3];
            if (arrTodoItemsNoPriority.count > 0) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrTodoItemsNoPriority.count - 1 inSection:3] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            } else if (arrTodoItemsPriorityLow.count > 0 ) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrTodoItemsPriorityLow.count - 1 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            } else if (arrTodoItemsPriorityMedium.count > 0) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrTodoItemsPriorityMedium.count - 1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            } else if (arrTodoItemsPriorityHight.count > 0) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrTodoItemsPriorityHight.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        } else if (_indexIsEditing == 2){
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_indexPath.row inSection:_indexPath.section] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
        isPriority = false;
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
        _priorityView.frame = CGRectMake(0, size.height, size.width, 20);
    }  completion:^(BOOL finished) {
        [self loadData];
        [self.tableView reloadData];
        _searchBar.frame = CGRectMake(_searchBar.frame.origin.x, _searchBar.frame.origin.y, _searchBar.frame.size.width - 70, 44);\
        [_priorityView removeFromSuperview];
    }];
}

#pragma mark - PriorityViewDelegate 

- (void) priorityHight {
    priority = 1;
}

- (void) priorityMedium {
    priority = 2;
}

- (void) priorityLow {
    priority = 3;
}
#pragma  mark TextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if (_indexIsEditing == 1) {
        isFiltered = NO;
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
            _todoItem.priority = priority;
            
            [_moneyDBController insert:TODOS data:[DBUtil ToDoItemToDBItem:_todoItem ]];
            [_txtItemTodo resignFirstResponder];
            _txtItemTodo.text = @"";
        }
        isPriority = true;

    }else if(_indexIsEditing == 2){
        
        NSIndexPath *indexPathSelected = [NSIndexPath indexPathForRow:_indexPath.row inSection:_indexPath.section];
        CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathSelected];
        
        NSArray *arrTodoItems = [[NSArray alloc] init];
        arrTodoItems = [_arrTodoItemsFollowPriorityAllSection objectAtIndex:_indexPath.section];
        TodoItem *todoItemEdit = [[TodoItem alloc] init];
        todoItemEdit = [arrTodoItems objectAtIndex:_indexPath.row];
        todoItemEdit.content = cell.txtTask.text;
        
        UpdateToDoItemToDatabase *updateTodoItemDatabase = [[UpdateToDoItemToDatabase alloc] initWithTodoItem:todoItemEdit];
        [updateTodoItemDatabase doQuery:_moneyDBController];
    }
    isFiltered = NO;
    //[self loadTodoItemsPriority];
    [self.tableView reloadData];
    _indexIsEditing = 0;
    priority = 0;
    return YES;
}

#pragma mark tableviewDatasource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (_segmentControl.selectedSegmentIndex == 1) {
        
        return _arrTitleSections.count;
    } else {
        if (isFiltered) {
            return 1;
        } else {
            return 4;
        }
    }
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (_segmentControl.selectedSegmentIndex == 1) {
        
        NSString *titleSection = [_arrTitleSections objectAtIndex:section];
        NSArray *arrRows = [_todoItemDictionarys objectForKey:titleSection];
        return arrRows.count;
    }
    if (_segmentControl.selectedSegmentIndex == 0) {
        if (isFiltered) {
            return _arrFilteredTodos.count;
        } else {
            NSArray *arrTodoItems = [_arrTodoItemsFollowPriorityAllSection objectAtIndex:section];
            return arrTodoItems.count;
        }
    }
    return _arrTodos.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifer];
   
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
    cell = [xib objectAtIndex:0];
    
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
   
    if (isFiltered) {
        TodoItem *todoItem = [[TodoItem alloc] init];
        if (_arrFilteredTodos.count) {
            todoItem = [_arrFilteredTodos objectAtIndex:indexPath.row];
            cell.txtTask.text = todoItem.content;
            cell.labelPomodoros.text = [NSString stringWithFormat:@"Pomodoros : %d", todoItem.pomodoros];
        }
        [_segmentControl setTitle:[NSString stringWithFormat:@"To Do (%lu)", (unsigned long)_arrFilteredTodos.count] forSegmentAtIndex:0];
    } else {
        if (_segmentControl.selectedSegmentIndex == 0) {
            
            NSArray *arrTodoItems = [_arrTodoItemsFollowPriorityAllSection objectAtIndex:indexPath.section];
            if (arrTodoItems.count > 0) {
                TodoItem *todoItem = [[TodoItem alloc] init];
                todoItem = [arrTodoItems objectAtIndex:indexPath.row];
                    
                cell.txtTask.text = todoItem.content;
                cell.labelPomodoros.text = [NSString stringWithFormat:@"Pomodoros : %d", todoItem.pomodoros];
            }
            
            UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(10, CELL_HEIGHT - 1, size.width - 10, 1)];/// change size as you need.
            separatorLineView.backgroundColor = [UIColor lightGrayColor];
            separatorLineView.alpha = 0.7f;// you can also put image here
            if (indexPath.section < 3) {
                if (indexPath.row != arrTodoItems.count - 1) {
                    [cell.contentView addSubview:separatorLineView];
                }
            } else {
                [cell.contentView addSubview:separatorLineView];
            }
        } else if (_segmentControl.selectedSegmentIndex == 1){
            
            NSString *titleSection = [_arrTitleSections objectAtIndex:indexPath.section];
            TodoItem *todoItemDict = [[TodoItem alloc] init];
            NSArray *arrTodoItem = [_todoItemDictionarys objectForKey:titleSection];
            todoItemDict = [arrTodoItem objectAtIndex:indexPath.row];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"hh:mm a"];
            cell.labelTime.text = [dateFormatter stringFromDate:todoItemDict.dateCompleted];
            cell.txtTask.text = todoItemDict.content;
            cell.labelPomodoros.text = [NSString stringWithFormat:@"Pomodoros : %d", todoItemDict.pomodoros];
            
            UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(10, CELL_HEIGHT - 1, size.width - 10, 1)];/// change size as you need.
            separatorLineView.backgroundColor = [UIColor lightGrayColor];
            separatorLineView.alpha = 0.7f;// you can also put image here
            if (indexPath.section != _arrTitleSections.count && _arrTitleSections.count > 1) {
                if (indexPath.row < arrTodoItem.count && arrTodoItem.count > 1) {
                    [cell.contentView addSubview:separatorLineView];
                }
            } else {
                [cell.contentView addSubview:separatorLineView];
            }
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *arrTodoItems = _arrTodoItemsFollowPriorityAllSection[indexPath.section];
    TodoItem *todoItem = arrTodoItems[indexPath.row];
    
    if (_segmentControl.selectedSegmentIndex == 0) {
        AlarmViewController *alarmViewController = [[AlarmViewController alloc] init];
        alarmViewController.stringContentTask = todoItem.content;
        
        [self.navigationController pushViewController:alarmViewController animated:YES];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_segmentControl.selectedSegmentIndex == 1) {
        
        return [_arrTitleSections objectAtIndex:section];
    } else {
        if (section == 0) {
            return @"section 1";
        }
        if (section == 2) {
            return @"section 2";
        }
    }
    return @"";
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_segmentControl.selectedSegmentIndex == 0) {
        if (section == 0) {
            viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 40)];
            if (isSearching) {
                _searchBar = [[UISearchBar alloc] init];
                doneOrCancelBtn = [[UIButton alloc] init];
                _searchBar.frame = CGRectMake(0, 0, size.width - 70, 40);
                _searchBar.text = stringSearching;
                _searchBar.delegate = self;
                
                doneOrCancelBtn.frame = CGRectMake(size.width - 70, 0, 70, 40);
                [doneOrCancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
                [doneOrCancelBtn setTitleColor:[UIColor colorWithRed:42.0f/255.0f green:94.0f/255.0f blue:253.0f/255.0f alpha:1] forState:UIControlStateNormal];
                [doneOrCancelBtn setBackgroundColor:[UIColor lightGrayColor]];
                [doneOrCancelBtn addTarget:self action:@selector(cancelOnClicked) forControlEvents:UIControlEventTouchUpInside];
                [viewHeader addSubview:_searchBar];
                [viewHeader addSubview:doneOrCancelBtn];
                
                NSArray *arrButtons = [[NSArray alloc] initWithObjects:@"This is project", @"All project", nil];
                segmentController = [[UISegmentedControl alloc] initWithItems:arrButtons];
                segmentController.frame = CGRectMake(0, _searchBar.frame.size.height, size.width, 20);
                segmentController.backgroundColor = [UIColor whiteColor];
                [segmentController addTarget:self action:@selector(selectSegmentControl) forControlEvents:UIControlEventValueChanged];
                segmentController.selectedSegmentIndex =  isSelectSegmentControl;
                [viewHeader addSubview:segmentController];
                
            } else {
                _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, size.width, 40)];
                _searchBar.placeholder = @"Enter key word";
                _searchBar.delegate = self;
                [viewHeader addSubview:_searchBar];
                doneOrCancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(_searchBar.frame.size.width, 0, 70, 40)];
                [doneOrCancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
                [doneOrCancelBtn setTitleColor:[UIColor colorWithRed:42.0f/255.0f green:94.0f/255.0f blue:253.0f/255.0f alpha:1] forState:UIControlStateNormal];
                [doneOrCancelBtn setBackgroundColor:[UIColor lightGrayColor]];
                
                [doneOrCancelBtn addTarget:self action:@selector(cancelOnClicked) forControlEvents:UIControlEventTouchUpInside];
                [viewHeader addSubview:doneOrCancelBtn];
                
                UIView *viewRed = [[UIView alloc] initWithFrame:CGRectMake(0, _searchBar.frame.size.height, size.width, 10)];
                NSArray *arrTodoItemsPriorityHight = [_arrTodoItemsFollowPriorityAllSection objectAtIndex:0];
                if (arrTodoItemsPriorityHight.count > 0) {
                    viewRed.backgroundColor = [UIColor redColor];
                }
                [viewHeader addSubview:viewRed];
            }
            return viewHeader;
        }
        if (section == 1) {
            UIView *viewBlue = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 10)];
            viewBlue.backgroundColor = [UIColor blueColor];
            return viewBlue;
        }
        if (section == 2) {
            UIView *viewYellow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 10)];
            viewYellow.backgroundColor = [UIColor yellowColor];
            return viewYellow;
        }
        if (section == 3) {
            UIView *viewWhite = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 10)];
            viewWhite.backgroundColor = [UIColor lightGrayColor];
            return viewWhite;
        }
    }
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_segmentControl.selectedSegmentIndex == 0) {
        if (section == 0) {
            NSArray *arrTodoItems = [_arrTodoItemsFollowPriorityAllSection objectAtIndex:0];
            if (isSearching || arrTodoItems.count > 0) {
                return 50;
            }
            return 40;
        }
        if (section == 1) {
            NSArray *arrTodoItems = [_arrTodoItemsFollowPriorityAllSection objectAtIndex:1];
            if (arrTodoItems.count == 0) {
                return 0;
            }
            return 10;
        }
        if (section == 2) {
            NSArray *arrTodoItems = [_arrTodoItemsFollowPriorityAllSection objectAtIndex:2];
            if (arrTodoItems.count == 0) {
                return 0;
            }
            return 10;
        }
        if (section == 3) {
            NSArray *arrTodoItems = [_arrTodoItemsFollowPriorityAllSection objectAtIndex:3];
            if (arrTodoItems.count == 0) {
                return 0;
            } else if (_arrTodoItemsPriorityHight.count == 0 && _arrTodoItemsPriorityMedium.count == 0 && _arrTodoItemsPriorityLow.count == 0){
                return 0;
            }
            return 10;
        }
    } else {
        return 30;
    }
    
    return 40;
}

- (void) selectSegmentControl {
    if (segmentController.selectedSegmentIndex == 0 ) {
        isSelectSegmentControl = false;
        [self searchTodos];
    } else {
        isSelectSegmentControl = true;
        if (stringSearching.length == 0) {
            isFiltered = NO;
        } else {
            isFiltered = YES;
            _arrFilteredTodos = [[NSMutableArray alloc] init];
            for (int i = 0; i < _arrAllTodoItems.count; i ++) {
                TodoItem *todoItem = [[TodoItem alloc] init];
                todoItem = [_arrAllTodoItems objectAtIndex:i];
                NSRange todoContentRange = [todoItem.content rangeOfString:stringSearching options:NSCaseInsensitiveSearch];
                if (todoContentRange.location != NSNotFound) {
                    [_arrFilteredTodos addObject:todoItem];
                }
            }
        }
        [self.tableView reloadData];
        [_searchBar resignFirstResponder];
    }
}
- (void) cancelOnClicked {
        isSearching = false;
        isFiltered = NO;
        _searchBar.text = @"";
        [_searchBar resignFirstResponder];
        [self.tableView reloadData];
        //doneOrCancelBtn.frame = CGRectMake(_searchBar.frame.size.width, 0, 70, 44);
}
#pragma mark - searcgBarDelegate

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    stringSearching = searchText;
}

- (void) searchTodos {
    if (stringSearching.length == 0) {
        isFiltered = NO;
    } else {
        isFiltered = YES;
        _arrFilteredTodos = [[NSMutableArray alloc] init];
        for (int i = 0; i < _arrTodos.count; i ++) {
            TodoItem *todoItem = [[TodoItem alloc] init];
            todoItem = [_arrTodos objectAtIndex:i];
            NSRange todoContentRange = [todoItem.content rangeOfString:stringSearching options:NSCaseInsensitiveSearch];
            if (todoContentRange.location != NSNotFound) {
                [_arrFilteredTodos addObject:todoItem];
            }
        }
    }
    
    [self.tableView reloadData];
    [_searchBar resignFirstResponder];
}
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
   
    isSearching = true;
    isSelectSegmentControl = false;
    _searchBar.text = stringSearching;
    [self searchTodos];
}

#pragma mark - SWTTableViewDelegate

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
            
            timerNotificationCenterItem.isRunTimer = false;
            [timerNotificationCenterItem.timer invalidate];
            timerNotificationCenterItem.timer = nil;
            timerNotificationCenterItem.isWorking = true;
            timerNotificationCenterItem.timeMinutes = _settingItem.timeWork;
            timerNotificationCenterItem.timeSeconds = 0;
            timerNotificationCenterItem.totalLongBreaking = 0;
            timerNotificationCenterItem.totalTime = _settingItem.timeWork * 60;
            totalTodos --;
            
            if (isFiltered ) {
                TodoItem *todoItem = _arrFilteredTodos [indexPath.row];
                todoItem.status = true;
                todoItem.dateCompleted = [NSDate date];
                
                UpdateToDoItemToDatabase *updateTodoItemTask = [[UpdateToDoItemToDatabase alloc]initWithTodoItem:todoItem];
                [updateTodoItemTask doQuery:_moneyDBController];
                
                DebugLog(@"update was accessesfully");
                [self.arrFilteredTodos removeObject:todoItem];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView reloadData];
            } else {
                if (totalTodos > 0) {
                    [_segmentControl setTitle:[NSString stringWithFormat:@"To Do (%ld)", (long)totalTodos] forSegmentAtIndex:0];
                } else {
                    [_segmentControl setTitle:[NSString stringWithFormat:@"To Do"] forSegmentAtIndex:0];
                }
                
                NSMutableArray *arrTodoItems = [_arrTodoItemsFollowPriorityAllSection objectAtIndex:indexPath.section];
                    TodoItem *todoItem = arrTodoItems [indexPath.row];
                    todoItem.status = true;
                    todoItem.dateCompleted = [NSDate date];
                    
                    UpdateToDoItemToDatabase *updateTodoItemTask = [[UpdateToDoItemToDatabase alloc]initWithTodoItem:todoItem];
                    [updateTodoItemTask doQuery:_moneyDBController];
                    
                    DebugLog(@"update was accessesfully");
                    [arrTodoItems removeObject:todoItem];
                [_arrTodoItemsFollowPriorityAllSection replaceObjectAtIndex:indexPath.section withObject:arrTodoItems];
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                
                [self.tableView reloadData];
            }
        } else {
            // Undone
            totalTodos ++;
            if (isFiltered) {
                
                TodoItem *todoItem = _arrFilteredTodos [indexPath.row];
                todoItem.status = false;
                UpdateToDoItemToDatabase *updateTodoItemTask = [[UpdateToDoItemToDatabase alloc]initWithTodoItem:todoItem];
                [updateTodoItemTask doQuery:_moneyDBController];
                
                DebugLog(@"update was accessesfully");
                [self.arrFilteredTodos removeObject:todoItem];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [self.tableView reloadData];
            } else {
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
                [self loadData];
                [self.tableView reloadData];
            }
        }
    }
}
- (void) swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    // index = 0 button is delete
     NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    _indexPathRow = indexPath.row;
    _indexPath = indexPath;
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
            
            NSMutableArray *arrTodoItems = [[NSMutableArray alloc] init];
            arrTodoItems = [_arrTodoItemsFollowPriorityAllSection objectAtIndexedSubscript:indexPath.section];
            TodoItem *todoItemRemoveFromTable = [arrTodoItems objectAtIndex:indexPath.row];
            _todoItemUndo = todoItemRemoveFromTable;
            
            [arrTodoItems removeObject:todoItemRemoveFromTable];
            [_arrTodoItemsFollowPriorityAllSection replaceObjectAtIndex:indexPath.section withObject:arrTodoItems];
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
            
            [self performSelector:@selector(deleteRowFromTableview) withObject:self afterDelay:2];
        }
        
        DebugLog(@"Press button is delete");
    }
    // index = 1 button is edit
    if (index == 1) {
        
        statusUseKeyboard = @"adding";
        [_tableView reloadData];
        _indexIsEditing = 2;
        isSearching = false;
        
        _indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        
        CustomTableViewCell *cellSelected = [_tableView cellForRowAtIndexPath:_indexPath];
        
        cellSelected.txtTask.enabled = YES;
        [cellSelected.txtTask becomeFirstResponder];
    }
    // index = 2 button is start
    if (index == 2) {
        [self.tableView reloadData];
        _indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.me.PomodoroWidget"];
        SettingItem *settingItem;;
        settingItem = appDelegate.settingItem;
        
        NSMutableArray *arrTodoItems = [[NSMutableArray alloc] init];
        arrTodoItems = [_arrTodoItemsFollowPriorityAllSection objectAtIndex:indexPath.section];
        TodoItem *todoItem = [TodoItem new];
        todoItem = [arrTodoItems objectAtIndex:indexPath.row];
        timerNotificationCenterItem.todoItem = todoItem;
        DebugLog(@"_indexPath: %@", _indexPath);
        if (_indexPath.row != settingItem.indexPathRow || _indexPath.section != settingItem.indexPathSection) { // so sách index path đang chạy timer vs index path vừa ấn có giống nhau hay không.. nếu không giống nhau thì chạy lại timer từ đâu
            isStartting = true;
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
            
            [userDefaults setInteger:_indexPath.row forKey:KEY_INDEXPATH_ROW];
            settingItem.indexPathRow = (int)_indexPath.row;
            
            [userDefaults setInteger:_indexPath.section forKey:KEY_INDEXPATH_SECTION];
            settingItem.indexPathSection = (int)_indexPath.section;
            
            [userDefaults setInteger:1 forKey:KEY_IS_ACTIVE];
            settingItem.isActive = 1;
            
            [userDefaults setInteger:0 forKey:KEY_IS_CHANGED];
            settingItem.isChanged = 0;
            
            [userDefaults setObject:@"Working" forKey:@"key_status_working"];
            [userDefaults setInteger:timerNotificationCenterItem.totalLongBreaking forKey:@"key_total_pomodoro"];
            [userDefaults setInteger:timerNotificationCenterItem.totalWorking forKey:@"key_total_work"];
            [userDefaults setInteger:timerNotificationCenterItem.timeMinutes forKey:@"key_time_minutes"];
            [userDefaults setInteger:timerNotificationCenterItem.timeSeconds forKey:@"key_time_seconds"];
            [userDefaults setObject:@"start_containing_app" forKey:@"key_timer_running"];
            
            isStartting = false;
            self.tabBarController.selectedIndex = 1;
            
        } else {
            
            if (!isStartting) {
                timerNotificationCenterItem.isRunTimer = isStartting; // gán giá trị isRunTimer = false thì timer invalidate
                [self updateLabelForCell];
                [appDelegate startStopTimer];
                isStartting = true;
                
                [userDefaults setObject:@"pause_containing_app" forKey:@"key_timer_running"];
                [userDefaults setInteger:timerNotificationCenterItem.timeMinutes forKey:@"key_time_minutes"];
                [userDefaults setInteger:timerNotificationCenterItem.timeSeconds forKey:@"key_time_seconds"];
                
            } else if (isStartting){
                
                timerNotificationCenterItem.isRunTimer = isStartting; // gán giá trị isRunTimer = true thì timer isvalid
                timerNotificationCenterItem.stringTaskname = todoItem.content;
                [userDefaults setInteger:1 forKey:KEY_IS_ACTIVE];
                settingItem.isActive = 1;
                self.tabBarController.selectedIndex = 1;
                isStartting = false;
                
                [userDefaults setInteger:timerNotificationCenterItem.totalLongBreaking forKey:@"key_total_pomodoro"];
                [userDefaults setInteger:timerNotificationCenterItem.totalWorking forKey:@"key_total_work"];
                [userDefaults setInteger:timerNotificationCenterItem.timeMinutes forKey:@"key_time_minutes"];
                [userDefaults setInteger:timerNotificationCenterItem.timeSeconds forKey:@"key_time_seconds"];
                [userDefaults setObject:@"start_containing_app" forKey:@"key_timer_running"];
            }
        }
    }
}

#pragma mark editableTableControllerDelegate

- (void) editableTableController:(EditableTableController *)controller willBeginMovingCellAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    NSMutableArray *arrTodoItemBeingMoves = _arrTodoItemsFollowPriorityAllSection[indexPath.section];
    self.todoItemBeingMove = [arrTodoItemBeingMoves objectAtIndex:indexPath.row];
    //self.todoItemBeingMove = [_arrTodos objectAtIndex:indexPath.row];
    //[_arrTodos replaceObjectAtIndex:indexPath.row withObject:self.todoItemBeingMove];
    [self.tableView endUpdates];
    
    DebugLog(@"____1 : %@", indexPath);
}

- (void) editableTableController:(EditableTableController *)controller movedCellWithInitialIndexPath:(NSIndexPath *)initialIndexPath fromAboveIndexPath:(NSIndexPath *)fromIndexPath toAboveIndexPath:(NSIndexPath *)toIndexPath {
    
    NSMutableArray *arrTodoItemsFromIndexPath = [_arrTodoItemsFollowPriorityAllSection objectAtIndex:fromIndexPath.section];
    NSMutableArray *arrTodoItemsToIndexPath = [_arrTodoItemsFollowPriorityAllSection objectAtIndex:toIndexPath.section];
    
    [self.tableView beginUpdates];
    [self.tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    [arrTodoItemsFromIndexPath removeObjectAtIndex:fromIndexPath.row];
    if (toIndexPath != NULL) {
        if (toIndexPath.row == arrTodoItemsToIndexPath.count) {
            [arrTodoItemsToIndexPath addObject:self.todoItemBeingMove];
        } else {
            [arrTodoItemsToIndexPath insertObject:self.todoItemBeingMove atIndex:toIndexPath.row];
        }
    }
    [self.tableView endUpdates];
    _toIndexPath = toIndexPath;
}
- (BOOL) editableTableController:(EditableTableController *)controller shouldMoveCellFromInitialIndexPath:(NSIndexPath *)initialIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath withSuperviewLocation:(CGPoint)location {
    
    CGRect exampleRect = (CGRect){0, 0,[[UIScreen mainScreen] bounds].size.width, CELL_HEIGHT};
    
    if (CGRectContainsPoint(exampleRect, location)) {
        [self updateDataAfterReoder];
        [self.tableView reloadData];
        return NO;
    }
    return YES;
}

- (void) editableTableController:(EditableTableController *)controller didMoveCellFromInitialIndexPath:(NSIndexPath *)initialIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    [self updateDataAfterReoder];
    DebugLog(@"___________4 : %@ - %@", initialIndexPath, toIndexPath);
}

- (void) updateDataAfterReoder {
    //NSMutableArray *arrTodoItemInitIndexPath = _arrTodoItemsFollowPriorityAllSection[initialIndexPath.section];
    NSMutableArray *arrTodoItemToIndexPath = _arrTodoItemsFollowPriorityAllSection[_toIndexPath.section];
    
    //DebugLog(@"%@___", arrTodoItemInitIndexPath);
    //DebugLog(@"%@____", arrTodoItemToIndexPath);
    if (_toIndexPath.section == 3) {
        self.todoItemBeingMove.priority = 0;
        UpdateToDoItemToDatabase *updateTodoItemDatabase = [[UpdateToDoItemToDatabase alloc] initWithTodoItem:self.todoItemBeingMove];
        [updateTodoItemDatabase doQuery:_moneyDBController];
    } else {
        self.todoItemBeingMove.priority = (int)_toIndexPath.row + 1;
        UpdateToDoItemToDatabase *updateTodoItemDatabase = [[UpdateToDoItemToDatabase alloc] initWithTodoItem:self.todoItemBeingMove];
        [updateTodoItemDatabase doQuery:_moneyDBController];
    }
    self.todoItemBeingMove = nil;
    [self loadTodoItemsPriority];
    
    
    
    for (int i = 0; i < [_arrTodoItemsFollowPriorityAllSection[_toIndexPath.section] count]; i ++) {
        
        TodoItem *todoItemToDatabase = [[TodoItem alloc] init];
        TodoItem *todoItemToReorder = [[TodoItem alloc] init];
        
        todoItemToDatabase = _arrTodoItemsFollowPriorityAllSection[_toIndexPath.section][i];
        todoItemToReorder = arrTodoItemToIndexPath[i];
        
        todoItemToDatabase.content = todoItemToReorder.content;
        todoItemToDatabase.status = todoItemToReorder.status;
        todoItemToDatabase.isDelete = todoItemToReorder.isDelete;
        todoItemToDatabase.dateCompleted = todoItemToReorder.dateCompleted;
        todoItemToDatabase.dateDeleted = todoItemToReorder.dateDeleted;
        todoItemToDatabase.projectID = todoItemToReorder.projectID;
        todoItemToDatabase.pomodoros = todoItemToReorder.pomodoros;
        todoItemToDatabase.priority = todoItemToReorder.priority;
        
        UpdateToDoItemToDatabase *updateTodoItemToDatabaseTask = [[UpdateToDoItemToDatabase alloc] initWithTodoItem:todoItemToDatabase];
        [updateTodoItemToDatabaseTask doQuery:_moneyDBController];
        [self.tableView reloadData];
    }
}
#pragma mark NSTimer
- (void) updateLabelForCell {  // khi timer invalidate thì label cell đc cập nhật lại cho đúng với thời gian timer dừng
    CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    cell.labelTime.text = [NSString stringWithFormat:@"%@ %@ ", timerNotificationCenterItem.stringStatusWorking,[self setTextLabelForCell:timerNotificationCenterItem.timeMinutes and: timerNotificationCenterItem.timeSeconds]];
}
- (void) updateLabelForCell: (NSNotification *) notification { // label cell đc cập nhật liên tục khi timer running
    
    if (_arrTodos.count != 0) {
        
        TodoItem *todoItem = [[TodoItem alloc] init];
        todoItem = [_arrTodos objectAtIndex:_indexPath.row];
        
        CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
        cell.labelTime.text = [NSString stringWithFormat:@"%@ %@ ", timerNotificationCenterItem.stringStatusWorking,[self setTextLabelForCell: timerNotificationCenterItem.timeMinutes and: timerNotificationCenterItem.timeSeconds]];
        cell.labelPomodoros.text = [NSString stringWithFormat:@"Pomodoros : %d", todoItem.pomodoros];
        
        if (timerNotificationCenterItem.timeMinutes == 0 && timerNotificationCenterItem.timeSeconds == 0) {
            DebugLog(@"____________%@", timerNotificationCenterItem.stringStatusWorking);
            if ([timerNotificationCenterItem.stringStatusWorking isEqualToString:@"Breaking"]) {
                
                [self pushNoteView:@"This is time to break"];
            } else if ([timerNotificationCenterItem.stringStatusWorking isEqualToString:@"Working"]) {
                
                [self pushNoteView:@"This is time to work"];
                
            } else if ([timerNotificationCenterItem.stringStatusWorking isEqualToString:@"Long Breaking"]) {
                
                [self pushNoteView:@"This is time to long break"];
            }
            if (_settingItem.isSound) {
                [self playSound];
            }
            
            [self performSelector:@selector(removePushView) withObject:nil afterDelay:3];
        }
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
        NSMutableArray *arrTodoItems = [_arrTodoItemsFollowPriorityAllSection objectAtIndex:_indexPath.section];
        [arrTodoItems insertObject:_todoItemUndo atIndex:_indexPath.row];
        [self.tableView reloadData];
        [self animateUndoViewWillBeHidden];
    } else {

        [self loadData];
        [self.tableView reloadData];
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
        _indexPath = nil;
            timerNotificationCenterItem.isRunTimer = false;
            [timerNotificationCenterItem.timer invalidate];
            timerNotificationCenterItem.timer = nil;
            timerNotificationCenterItem.isWorking = true;
            timerNotificationCenterItem.timeMinutes = _settingItem.timeWork;
            timerNotificationCenterItem.timeSeconds = 0;
            timerNotificationCenterItem.totalLongBreaking = 0;
            timerNotificationCenterItem.totalWorking = 0;
            timerNotificationCenterItem.totalTime = _settingItem.timeWork * 60;
            
            [_shareUserDefaults setObject:@"stop_containing_app" forKey:@"key_timer_running"];
        
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










@end
