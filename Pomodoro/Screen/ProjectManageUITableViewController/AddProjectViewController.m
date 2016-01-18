//
//  AddProjectViewController.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "AddProjectViewController.h"
#import "DBUtil.h"
#import "UpdateProjectManageItemToDatabaseTask.h"
#import "SelectDeadlineViewController.h"


@interface AddProjectViewController ()<UITextFieldDelegate, UITextViewDelegate, SelectDeadlineViewControllerDelegate>

@property (nonatomic, strong) MoneyDBController *moneyDBController;
@end

@implementation AddProjectViewController
{
    CGSize size;
    NSTimer *timer;
    UILabel *labelAlert;
    CGFloat heightTabbar;
    NSDate *datePicker;
    UIButton *cancelButton;
    UIButton *doneButton;
    UIView *viewDatePicker;
    BOOL isDatePicking;
    BOOL isFillingInfomation;
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isDatePicking = true;
    isFillingInfomation = true;
    
    _moneyDBController = [MoneyDBController getInstance];
    size = [[UIScreen mainScreen] bounds].size;
    heightTabbar = self.tabBarController.tabBar.bounds.size.height;
    
    _txtDescription.delegate = self;
    _txtProjectname.delegate = self;
    
    
}

- (void) setupView {
    _txtDescription.layer.borderColor = [UIColor blackColor].CGColor;
    _txtDescription.layer.borderWidth = 1;
    _txtDescription.text = @"";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self
                                                                                           action:@selector(saveProject)];
    if ([_stringTitle isEqualToString:@"edit"]) {
        
        self.title = @"Edit";
        NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
        [dateFomatter setDateFormat:@"yyyy / MM / dd"];
        
        _txtProjectname.text = _projectManageItem.projectName;
        _txtDescription.text = _projectManageItem.projectDescription;
        if ([[dateFomatter stringFromDate:_projectManageItem.endDate] isEqualToString:@"1970 / 01 / 01"]) {
//            _selectDateBtn.titleLabel.text = @"SELECT DATE";
            [_selectDateBtn setTitle:@"SELECT DATE" forState:UIControlStateNormal];
        } else {
            [_selectDateBtn setTitle:[dateFomatter stringFromDate:_projectManageItem.endDate] forState:UIControlStateNormal];;
        }
        
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
//                                                                                 style:UIBarButtonItemStyleDone
//                                                                                target:self
//                                                                                action:@selector(backDetailProjectManageViewController)];
        if ([_projectManageItem.description isEqualToString:@"(null)"]) {
            _txtDescription.text = @"";
        }
    } else {
        self.title = @"Adding";
    }
}

- (void) backDetailProjectManageViewController {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - delegate textfield and textview

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [_txtProjectname resignFirstResponder];
    if ([_stringTitle isEqualToString:@"edit"]) {
        _projectManageItem.projectDescription = textField.text;
        
        UpdateProjectManageItemToDatabaseTask *updateProjectManageItemToDatabaseTask = [[UpdateProjectManageItemToDatabaseTask alloc] initWithProjectManageItem:_projectManageItem];
        [updateProjectManageItemToDatabaseTask doQuery:_moneyDBController];
    }
    return YES;
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [_txtDescription resignFirstResponder];
        
        if ([_stringTitle isEqualToString:@"edit"]) {
            _projectManageItem.projectDescription = _txtDescription.text;
            
            DebugLog(@"___%@ ",_txtProjectname.text);
            UpdateProjectManageItemToDatabaseTask *updateProjectManageItemToDatabaseTask = [[UpdateProjectManageItemToDatabaseTask alloc] initWithProjectManageItem:_projectManageItem];
            [updateProjectManageItemToDatabaseTask doQuery:_moneyDBController];
        }
        return NO;
    }
    
    return YES;
}
#pragma mark - button select date

- (IBAction)selectDateOnClicked:(id)sender {
    
    [_txtDescription resignFirstResponder];
    [_txtProjectname resignFirstResponder];
    if ([_stringTitle isEqualToString:@"edit"]) {
        _projectManageItem.projectDescription = _txtDescription.text;
        
        DebugLog(@"___%@ ",_txtProjectname.text);
        UpdateProjectManageItemToDatabaseTask *updateProjectManageItemToDatabaseTask = [[UpdateProjectManageItemToDatabaseTask alloc] initWithProjectManageItem:_projectManageItem];
        [updateProjectManageItemToDatabaseTask doQuery:_moneyDBController];
    }
    SelectDeadlineViewController *selectDeadlineViewController;
    if (!selectDeadlineViewController) {
        selectDeadlineViewController = [[SelectDeadlineViewController alloc] init];
    }
    selectDeadlineViewController.stringTitle = _stringTitle;
    selectDeadlineViewController.projectManagerItem = _projectManageItem;
    selectDeadlineViewController.delegate = self;
    [self.navigationController pushViewController:selectDeadlineViewController animated:YES];
    
}
#pragma mark SelectDeadlineViewControllerDelegate

- (void) selectedDate:(NSDate *)_datePicker {
    
    NSDateFormatter *dateFommater = [[NSDateFormatter alloc] init];
    [dateFommater setDateFormat:@"yyyy / MM / dd"];
    
    DebugLog(@"date : %@", [dateFommater stringFromDate: _datePicker]);
    
    datePicker = _datePicker;
    [_selectDateBtn setTitle:[dateFommater stringFromDate:_datePicker] forState:UIControlStateNormal];
}
//- (void) initDatePickerAndDoneCancelButtons {
//    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, size.width, 200)];
//    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width / 2, 200, size.width / 2 - 1, 40)];
//    doneButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 200, size.width / 2 - 1, 40)];
//    datePicker.datePickerMode = UIDatePickerModeDate;
//    [self.view addSubview:datePicker];
//    
//    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
//    [cancelButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//    cancelButton.layer.borderWidth = 1;
//    cancelButton.layer.borderColor = [UIColor greenColor].CGColor;
//    cancelButton.layer.cornerRadius = 3;
//    
//    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
//    [doneButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//    doneButton.layer.borderWidth = 1;
//    doneButton.layer.borderColor = [UIColor greenColor].CGColor;
//    doneButton.layer.cornerRadius = 3;
//    
//    [self.view addSubview:cancelButton];
//    [self.view addSubview:doneButton];
//    
//    [cancelButton addTarget:self
//                     action:@selector(cancelButtonOnClicked)
//           forControlEvents:UIControlEventTouchUpInside];
//    [doneButton addTarget:self
//                   action:@selector(doneButtonOnClicked)
//         forControlEvents:UIControlEventTouchUpInside];
//    viewDatePicker = [[UIView alloc] initWithFrame:CGRectMake(0, size.height - heightTabbar, size.width, 240)];
//    [viewDatePicker addSubview:datePicker];
//    [viewDatePicker addSubview:doneButton];
//    [viewDatePicker addSubview:cancelButton];
//    [self.view addSubview:viewDatePicker];
//    [UIView animateWithDuration:1 animations:^{
//        viewDatePicker.frame = CGRectMake(0, size.height - heightTabbar - 240, size.width, 240) ;
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//- (void) cancelButtonOnClicked {
//    
//    [self removeDatePickerAndDoneCancelButtons];
//}
//
//- (void) doneButtonOnClicked {
//    
//    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
//    [dateFomatter setDateFormat:@"yyyy / MM / dd"];
//    
//    [_selectDateBtn setTitle:[NSString stringWithFormat:@"%@", [dateFomatter stringFromDate:datePicker.date]] forState:UIControlStateNormal];
//    [self removeDatePickerAndDoneCancelButtons];
//}

#pragma mark - button Done

- (void) saveProject {
    
    if (![_txtProjectname.text isEqualToString:@""]) {
        
        if ([_stringTitle isEqualToString:@"add"]) {
            ProjectManageItem *projectManageItem = [ProjectManageItem new];
            projectManageItem.projectName = _txtProjectname.text;
            projectManageItem.projectDescription = _txtDescription.text;
            projectManageItem.startDate = [NSDate date];
            projectManageItem.endDate = datePicker;
            
            [_moneyDBController insert:PROJECTMANAGE data:[DBUtil projectManageItemToDBItem:projectManageItem]];
        } else if ([_stringTitle isEqualToString:@"edit"]) {
            _projectManageItem.projectName = _txtProjectname.text;
            _projectManageItem.projectDescription = _txtDescription.text;
            
            UpdateProjectManageItemToDatabaseTask *updateProjectManageItemToDatabaseTask = [[UpdateProjectManageItemToDatabaseTask alloc] initWithProjectManageItem:_projectManageItem];
            [updateProjectManageItemToDatabaseTask doQuery:_moneyDBController];
            [_delegate updateInfomationProject:_projectManageItem];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        if (isFillingInfomation) {
            isFillingInfomation = false;
            [_txtDescription resignFirstResponder];
            [_txtProjectname resignFirstResponder];
            labelAlert = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width / 2, 40)];
            labelAlert.center = CGPointMake(size.width / 2, size.height - 100);
            labelAlert.adjustsFontSizeToFitWidth = YES;
            labelAlert.text = @"Fill complete information";
            [self.view addSubview:labelAlert];
            
        }
        [self performSelector:@selector(removeLabelAlert) withObject:nil afterDelay:3];
    }
}

- (void) removeLabelAlert {
    
    [UIView animateWithDuration:2 animations:^{
        labelAlert.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [labelAlert removeFromSuperview];
        isFillingInfomation = true;
    }];
    
}

- (void) removeDatePickerAndDoneCancelButtons {
    
    [UIView animateWithDuration:1 animations:^{
        viewDatePicker.frame = CGRectMake(0, size.height - heightTabbar, size.width, 240);
    } completion:^(BOOL finished) {
        [viewDatePicker removeFromSuperview];
        isDatePicking = true;
    }];
}









@end
