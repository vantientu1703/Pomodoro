//
//  DetailProjectManageViewController.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/27/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "DetailProjectManageViewController.h"
#import "AddProjectViewController.h"
#import "DeleteProjectManageToDatabaseTask.h"
#import "UIColumnView.h"
#import "ColumnChartConfig.h"
#import "UIColumnChartView.h"
#import "MLColumnData.h"
#import <QuartzCore/QuartzCore.h>
#import "GetTodoItemWasDoneOrderByDateCompletedTask.h"
#import "GetDataChartItemToDatabaseTask.h"
#import "DataChartItem.h"
#import "GetTodoItemInProjectToDatabaseTask.h"
#import "DeleteTodoItemToDatabaseTask.h"
#import "GetTodoItemIsDeletedTask.h"
#import "GetToDoItemIsDoingToDatabase.h"
#import "GetTodoItemWasDoneOrderByDateCompletedTask.h"
#import "GetTodoItemIsDeletedFollowProjectIDToDatabaseTask.h"

#define CELL_HEIGHT 40

@interface DetailProjectManageViewController () <UIScrollViewDelegate, AddProjectManagerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *detailDataChartScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) MoneyDBController *moneyDBController;
@property (weak, nonatomic) IBOutlet UIScrollView *monthScrollView;


@end

@implementation DetailProjectManageViewController
{
    UIColumnChartView *chartView;
    UIColumnView *uiColumnView;
    ColumnChartConfig *columnChartConfig;
    
    NSMutableArray *arrMonthYearDataChart;
    NSMutableArray *dataChart;
    NSMutableArray *arrTodoItemDones;
    
    UIView *viewGrayBackground;
    
    BOOL isShowSelectMonth;
    
    
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = _projectManageItem.projectName;
    _segumnentedControl.selectedSegmentIndex = -1;
    isShowSelectMonth = false;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _moneyDBController = [MoneyDBController getInstance];
    
    isShowSelectMonth = false;
    GetTodoItemWasDoneOrderByDateCompletedTask *getTodoItemWasDoneOrderByDateCompletedTask = [[GetTodoItemWasDoneOrderByDateCompletedTask alloc] init];
    arrTodoItemDones = [getTodoItemWasDoneOrderByDateCompletedTask getTodoItemToDatbase:_moneyDBController where:[NSArray arrayWithObject:[NSString stringWithFormat:@"%ld",self.projectManageItem.projectID]]];
    
    GetDataChartItemToDatabaseTask *getDataChartItemToDatabaseTask = [[GetDataChartItemToDatabaseTask alloc] init];
    arrMonthYearDataChart = [getDataChartItemToDatabaseTask getDataChartItemToDatabase:_moneyDBController];
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    [dateFomatter setDateFormat:@"MM / yyyy"];
    
    if ([arrMonthYearDataChart count] == 0) {
        
        DataChartItem *dataChartItem = [[DataChartItem alloc] init];
        dataChartItem.monthYear = [NSDate date];
        [_moneyDBController insert:DATACHART data:[DBUtil dataChartToDBItem:dataChartItem]];
    } else {
        BOOL test = false;
        for (int i = 0; i < arrMonthYearDataChart.count; i ++) {
            DataChartItem *dataChartItem = [[DataChartItem alloc] init];
            dataChartItem = arrMonthYearDataChart[i];
            
            if ([[dateFomatter stringFromDate:dataChartItem.monthYear] isEqualToString:[dateFomatter stringFromDate:[NSDate date]]]) {
                test = true;
            }
        }
        if (!test) {
            DataChartItem *dataChartItem = [[DataChartItem alloc] init];
            dataChartItem.monthYear = [NSDate date];
            [_moneyDBController insert:DATACHART data:[DBUtil dataChartToDBItem:dataChartItem]];
        }
    }
    [self setupView];
    [self loadDataMonth];
    [self loadDataChart:[NSDate date]];
    [self loadDetailDatatChart];
}

#pragma mark - setup view 

- (void) setupView {
    self.scrollView.layer.cornerRadius = 5;
    self.detailDataChartScrollView.layer.cornerRadius = 5;
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    [dateFomatter setDateFormat:@"yyyy - MM - dd"];
    _desscriptTextView.editable = NO;
    _nameProject.text = _projectManageItem.projectName;
    _startDate.text = [dateFomatter stringFromDate:_projectManageItem.startDate];
    
    if ([[dateFomatter stringFromDate:_projectManageItem.endDate] isEqualToString:@"1970 - 01 - 01"]) {
        _endDate.text = @"NO SELECT";
    } else {
        _endDate.text = [dateFomatter stringFromDate:_projectManageItem.endDate];
    }
    if ([_projectManageItem.projectDescription isEqual:@"(null)"]) {
        _desscriptTextView.text = @"write something ...";
    } else {
        _desscriptTextView.text = _projectManageItem.projectDescription;
    }
    
    NSArray *arrTotoItems = [GetToDoItemIsDoingToDatabase getTodoItemToDatabase:_moneyDBController where:[NSArray arrayWithObject:[NSString stringWithFormat:@"%ld",_projectManageItem.projectID]]];
    _totalTodo.text = [NSString stringWithFormat:@"%lu", (unsigned long)arrTotoItems.count];
    
    GetTodoItemWasDoneOrderByDateCompletedTask *getTodoItemWasDoneOrderByDateCompleted = [[GetTodoItemWasDoneOrderByDateCompletedTask alloc] init];
    NSArray *arrToDones = [getTodoItemWasDoneOrderByDateCompleted getTodoItemToDatbase:_moneyDBController where:[NSArray arrayWithObject:[NSString stringWithFormat:@"%ld",_projectManageItem.projectID]]];
    _totalToDone.text = [NSString stringWithFormat:@"%lu", (unsigned long)arrToDones.count];
}

- (void) updateInfomationProject:(ProjectManageItem *)projectManagerItem {
    _projectManageItem = projectManagerItem;
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    [dateFomatter setDateFormat:@"yyyy - MM - dd"];
    _desscriptTextView.editable = NO;
    _nameProject.text = _projectManageItem.projectName;
    _startDate.text = [dateFomatter stringFromDate:_projectManageItem.startDate];
    
    if ([[dateFomatter stringFromDate:_projectManageItem.endDate] isEqualToString:@"1970 - 01 - 01"]) {
        _endDate.text = @"NO SELECT";
    } else {
        _endDate.text = [dateFomatter stringFromDate:_projectManageItem.endDate];
    }
    if ([_projectManageItem.projectDescription isEqualToString:@""]) {
        _desscriptTextView.text = @"";
    } else {
        _desscriptTextView.text = _projectManageItem.projectDescription;
    }
    
    NSArray *arrTotoItems = [GetToDoItemIsDoingToDatabase getTodoItemToDatabase:_moneyDBController where:[NSArray arrayWithObject:[NSString stringWithFormat:@"%ld",_projectManageItem.projectID]]];
    _totalTodo.text = [NSString stringWithFormat:@"%lu", (unsigned long)arrTotoItems.count];
    
    GetTodoItemWasDoneOrderByDateCompletedTask *getTodoItemWasDoneOrderByDateCompleted = [[GetTodoItemWasDoneOrderByDateCompletedTask alloc] init];
    NSArray *arrToDones = [getTodoItemWasDoneOrderByDateCompleted getTodoItemToDatbase:_moneyDBController where:[NSArray arrayWithObject:[NSString stringWithFormat:@"%ld",_projectManageItem.projectID]]];
    _totalToDone.text = [NSString stringWithFormat:@"%lu", (unsigned long)arrToDones.count];
}
#pragma mark - loadData
- (void) loadDataMonth {
    self.monthScrollView.delegate = self;
    CGSize size = [[UIScreen mainScreen] bounds].size;
    self.monthScrollView.pagingEnabled = YES;
    self.monthScrollView.contentSize = CGSizeMake(size.width * arrMonthYearDataChart.count, self.monthScrollView.frame.size.height);
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    [dateFomatter setDateFormat:@"MM / yyyy"];
    
    for (int i = 0; i < arrMonthYearDataChart.count; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * size.width, 0, size.width, self.monthScrollView.frame.size.height)];
        view.backgroundColor = [UIColor greenColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, self.monthScrollView.frame.size.height)];
        
        DataChartItem *dataChartItem = [[DataChartItem alloc] init];
        dataChartItem = arrMonthYearDataChart[i];
        label.text = [dateFomatter stringFromDate:dataChartItem.monthYear];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        [self.monthScrollView addSubview:view];
    }
    for (int i = 0; i < arrMonthYearDataChart.count; i ++) {
        DataChartItem *dataChartItem = [[DataChartItem alloc] init];
        dataChartItem = arrMonthYearDataChart[i];
        if ([[dateFomatter stringFromDate:[NSDate date]] isEqualToString:[dateFomatter stringFromDate:dataChartItem.monthYear]]) {
            self.scrollView.contentOffset = CGPointMake(size.width * i, 0);
        }
    }
}
- (void) loadDataChart: (NSDate *) date {
    
    chartView = [[UIColumnChartView alloc]initWithFrame:CGRectMake(0, 0, 600, self.scrollView.frame.size.height)];
    [chartView setAliasNameDelegate:self];
    dataChart = [[NSMutableArray alloc] init];
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    [dateFomatter setDateFormat:@"yyyy"];
    NSString *stringYear = [dateFomatter stringFromDate:date];
    [dateFomatter setDateFormat:@"MM"];
    NSString *stringMonth = [dateFomatter stringFromDate:date];
    
    if ([stringMonth isEqualToString:@"01"] || [stringMonth isEqualToString:@"03"] || [stringMonth isEqualToString:@"05"] || [stringMonth isEqualToString:@"07"] || [stringMonth isEqualToString:@"08"] || [stringMonth isEqualToString:@"10"] || [stringMonth isEqualToString:@"12"]) {
        for (int i = 0; i < 31; i ++) {
            MLColumnData *colData = [[MLColumnData alloc] initWithTitle:[NSString stringWithFormat:@"%d",i + 1] :0 :0 :@""];
            [dataChart addObject:colData];
        }
    } else if ([stringMonth isEqualToString:@"02"]) {
        if ([stringYear intValue] % 4 ==0) {
            for (int i = 0; i < 29; i ++) {
                MLColumnData *colData = [[MLColumnData alloc] initWithTitle:[NSString stringWithFormat:@"%d", i+1] :0 :0 :@"" ];
                [dataChart addObject:colData];
            }
        } else {
            for (int i = 0; i < 28; i ++) {
                MLColumnData *colData = [[MLColumnData alloc] initWithTitle:[NSString stringWithFormat:@"%d", i+1] :0 :0 :@"" ];
                [dataChart addObject:colData];
            }
        }
    } else {
        for (int i = 0; i < 30; i ++) {
            MLColumnData *colData = [[MLColumnData alloc] initWithTitle:[NSString stringWithFormat:@"%d",i] :0 :0 :@""];
            [dataChart addObject:colData];
        }
    }
    
    for (int i = 0; i < dataChart.count; i ++) {
        
        NSString *stringDate;
        if (i + 1 >= 10) {
            stringDate = [NSString stringWithFormat:@"%d",i + 1];
        } else {
            stringDate = [NSString stringWithFormat:@"0%d", i + 1];
        }
        
        int index = 0;
        for (int j = 0; j < arrTodoItemDones.count; j ++) {
            
            TodoItem *todoItem = [[TodoItem alloc] init];
            todoItem = arrTodoItemDones[j];
            [dateFomatter setDateFormat:@"MM - yyyy"];
            
            DebugLog(@"%@______", [dateFomatter stringFromDate:todoItem.dateCompleted]);
            if ([[dateFomatter stringFromDate:date] isEqualToString:[dateFomatter stringFromDate:todoItem.dateCompleted]]) {
                [dateFomatter setDateFormat:@"dd"];
                if ([stringDate isEqualToString:[dateFomatter stringFromDate:todoItem.dateCompleted]]) {
                    index ++;
                }
            }
        }
        MLColumnData *colData = [[MLColumnData alloc] initWithTitle:[NSString stringWithFormat:@"%d",i + 1] :index :0 :@"" ];
        [dataChart replaceObjectAtIndex:i withObject:colData];
    }
    
    [chartView setChart_data:dataChart];
    
    ColumnChartConfig *_chart_config = [[ColumnChartConfig alloc] init];
    [_chart_config setColorPositive:[UIColor blueColor]];
    [_chart_config setIsShowLine:YES];
    [_chart_config setFontSizeXSeries:12];
    [_chart_config setFontSizeYSeries:12];
    
    [chartView setChartConfig:_chart_config];
    [chartView reConfigChart];
    
    self.scrollView.contentSize = CGSizeMake(chartView.frame.size.width + 20, self.scrollView.frame.size.height);
    [self.scrollView addSubview:chartView];
}

- (void) loadDetailDatatChart {
    //self.detailDataChartScrollView.backgroundColor = [UIColor blueColor];
    CGSize mainScreen = [[UIScreen mainScreen] bounds].size;
    CGFloat HEIGHT_VIEWDETAIL = 40;
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreen.width - 20, HEIGHT_VIEWDETAIL * dataChart.count)];
    [self.detailDataChartScrollView addSubview:mainView];
    
    for (int i = 0; i < dataChart.count; i ++) {
        UIView *viewDetail = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT_VIEWDETAIL * i, mainView.frame.size.width, HEIGHT_VIEWDETAIL)];
        [mainView addSubview:viewDetail];
        UILabel *labelMonth = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 100, 20)];
        labelMonth.text = [NSString stringWithFormat:@"Day %i", i+1];
        labelMonth.textColor = [UIColor blackColor];
        [viewDetail addSubview:labelMonth];
        UILabel *labelTotalDone = [[UILabel alloc] initWithFrame:CGRectMake(mainView.frame.size.width - 110, 10, 100, 20)];
        
        MLColumnData *colData = [[MLColumnData alloc] init];
        colData = dataChart[i];
        labelTotalDone.text = [NSString stringWithFormat:@"%3.0f",colData.positiveValue];
        labelTotalDone.textColor = [UIColor blackColor];
        labelTotalDone.textAlignment = NSTextAlignmentRight;
        [viewDetail addSubview:labelTotalDone];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, mainView.frame.size.width, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [viewDetail addSubview:lineView];
    }
    self.detailDataChartScrollView.contentSize = CGSizeMake(mainScreen.width - 20, mainView.frame.size.height);
    
}
- (NSString *)onAliasName:(double)value {
    return [NSString stringWithFormat:@"%.0f",value];
}

#pragma mark - UIScrollViewDelehate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    DebugLog(@"%@", [dateFormatter stringFromDate:date]);
    
    int numberOrder = self.scrollView.contentOffset.x / [[UIScreen mainScreen] bounds].size.width;
    DataChartItem *dataChartItem = [[DataChartItem alloc] init];
    dataChartItem = arrMonthYearDataChart[numberOrder];
    [self loadDataChart:dataChartItem.monthYear];
}

#pragma mark - Implement all buttons
- (IBAction)selectSegumented:(id)sender {
    switch (_segumnentedControl.selectedSegmentIndex) {
        case 0:
        {
            AddProjectViewController *addProjectViewController;
            if (!addProjectViewController) {
                addProjectViewController = [[AddProjectViewController alloc] init];
            }
            addProjectViewController.stringTitle = @"edit";
            addProjectViewController.projectManageItem = _projectManageItem;
            addProjectViewController.delegate = self;
            [self.navigationController pushViewController:addProjectViewController animated:YES];
            _segumnentedControl.selectedSegmentIndex = -1;
        }
            break;
        case 1:
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reminder"
                                                                                     message:@"Are you make sure want to delete ?"
                                                                              preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", @"Ok Action") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                GetTodoItemIsDeletedFollowProjectIDToDatabaseTask *getTodoItemIsDeletedFollowProjectIDToDatabaseTask = [[GetTodoItemIsDeletedFollowProjectIDToDatabaseTask alloc] init];
                NSArray *arrTodoItems = [getTodoItemIsDeletedFollowProjectIDToDatabaseTask getTodoItemToDatabase:_moneyDBController whereProjectID:(int)_projectManageItem.projectID];
                
                if (arrTodoItems.count > 0) {
                    for (int i = 0; i < arrTodoItems.count; i ++) {
                        TodoItem *todoItem = [arrTodoItems objectAtIndex:i];
                
                        DeleteTodoItemToDatabaseTask *deleteTodoItemToDatabaseTask = [[DeleteTodoItemToDatabaseTask alloc] initWithTodoItem:todoItem];
                        [deleteTodoItemToDatabaseTask doQuery:_moneyDBController];
                    }
                }
                DeleteProjectManageToDatabaseTask *deleteProjectManageItemToDatabase = [[DeleteProjectManageToDatabaseTask alloc] initWithProjectManage:_projectManageItem];
                [deleteProjectManageItemToDatabase doQuery:_moneyDBController];
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel Action") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertController addAction:deleteAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            _segumnentedControl.selectedSegmentIndex = -1;
        }
        default:
            break;
    }
}

- (void) backProjectManageViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
