//
//  SelectDeadlineViewController.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 1/15/16.
//  Copyright © 2016 ZooStudio. All rights reserved.
//

#import "SelectDeadlineViewController.h"
#import "UpdateProjectManageItemToDatabaseTask.h"


@interface SelectDeadlineViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation SelectDeadlineViewController
{
    MoneyDBController *moneyDBController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Seclect Deadline";
    moneyDBController = [MoneyDBController getInstance];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveDatePicker)];
    
    if ([_stringTitle isEqualToString:@"edit"]) {
        NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
        [dateFomatter setDateFormat:@"yyyy - MM"];
        if (![[dateFomatter stringFromDate:_projectManagerItem.endDate] isEqualToString:@"1970 - 01"]) {
            [_datePicker setDate:_projectManagerItem.endDate animated:YES];
        }
    }
}

- (void) saveDatePicker {
    
    if ([_stringTitle isEqualToString:@"edit"]) {
        _projectManagerItem.endDate = [_datePicker date];
        UpdateProjectManageItemToDatabaseTask *updateProjectManagerItemToDatabaseTask = [[UpdateProjectManageItemToDatabaseTask alloc] initWithProjectManageItem:_projectManagerItem];
        [updateProjectManagerItemToDatabaseTask doQuery:moneyDBController];
    } else {
        [_delegate selectedDate:[_datePicker date]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
