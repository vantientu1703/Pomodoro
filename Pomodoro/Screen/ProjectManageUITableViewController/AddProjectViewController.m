//
//  AddProjectViewController.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "AddProjectViewController.h"
#import "DBUtil.h"

@interface AddProjectViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) MoneyDBController *moneyDBController;
@end

@implementation AddProjectViewController
{
    CGSize size;
    NSTimer *timer;
    UILabel *labelAlert;
    CGFloat heightTabbar;
    UIDatePicker *datePicker;
    UIButton *cancelButton;
    UIButton *doneButton;
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _moneyDBController = [MoneyDBController getInstance];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    size = [[UIScreen mainScreen] bounds].size;
    heightTabbar = self.tabBarController.tabBar.bounds.size.height;
    _txtDescription.delegate = self;
    _txtProjectname.delegate = self;
    [self setupView];
}

- (void) setupView {
    
    _txtDescription.layer.borderColor = [UIColor blackColor].CGColor;
    _txtDescription.layer.borderWidth = 1;
    _txtDescription.text = @"";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self
                                                                                           action:@selector(saveProject)];
}

#pragma mark - delegate textfield and textview

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [_txtProjectname resignFirstResponder];
    return YES;
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [_txtDescription resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma mark - button select date

- (IBAction)selectDateOnClicked:(id)sender {
    
    [_txtDescription resignFirstResponder];
    [_txtProjectname resignFirstResponder];
    
    //if (!datePicker && !cancelButton && !doneButton) {
        UIDatePicker *datePickerInstantype = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, size.width, 200)];
        UIButton *cancelButtonInstantype = [[UIButton alloc] initWithFrame:CGRectMake(size.width / 2, size.height - heightTabbar - 40, size.width / 2 - 1, 40)];
        UIButton *doneButtonInstantype = [[UIButton alloc] initWithFrame:CGRectMake(1, size.height - heightTabbar - 40, size.width / 2 - 1, 40)];
        
        datePicker = datePickerInstantype;
        cancelButton = cancelButtonInstantype;
        doneButton = doneButtonInstantype;
    //}
    
    datePicker.center = CGPointMake(size.width / 2, size.height - heightTabbar - 140);
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:datePicker];
    
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.borderColor = [UIColor greenColor].CGColor;
    cancelButton.layer.cornerRadius = 3;
    
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    doneButton.layer.borderWidth = 1;
    doneButton.layer.borderColor = [UIColor greenColor].CGColor;
    doneButton.layer.cornerRadius = 3;
    
    [self.view addSubview:cancelButton];
    [self.view addSubview:doneButton];
    
    [cancelButton addTarget:self
                     action:@selector(cancelButtonOnClicked)
           forControlEvents:UIControlEventTouchUpInside];
    [doneButton addTarget:self
                   action:@selector(doneButtonOnClicked)
         forControlEvents:UIControlEventTouchUpInside];


}

- (void) cancelButtonOnClicked {
    
    [self removeButtonAndDatePicker];
}

- (void) doneButtonOnClicked {
    
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    [dateFomatter setDateFormat:@"yyyy / MM / dd"];
    
    [_selectDateBtn setTitle:[NSString stringWithFormat:@"%@", [dateFomatter stringFromDate:datePicker.date]] forState:UIControlStateNormal];
    [self removeButtonAndDatePicker];
}

#pragma mark - button Done

- (void) saveProject {
    
    DebugLog(@"textview : %@", _txtDescription.text);
    
    if (![_txtProjectname.text isEqualToString:@""]) {
        
        ProjectManageItem *projectManageItem = [ProjectManageItem new];
        projectManageItem.projectName = _txtProjectname.text;
        projectManageItem.projectDescription = _txtDescription.text;
        projectManageItem.startDate = [NSDate date];
        projectManageItem.endDate = [datePicker date];
        
        [_moneyDBController insert:projectmanage data:[DBUtil projectManageItemToDBItem:projectManageItem]];
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        labelAlert = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width / 2, 40)];
        labelAlert.center = CGPointMake(size.width / 2, size.height - 100);
        labelAlert.adjustsFontSizeToFitWidth = YES;
        labelAlert.text = @"Fill complete information";
        [self.view addSubview:labelAlert];
        
        [self performSelector:@selector(removeLabelAlert) withObject:nil afterDelay:3];
    }
}

- (void) removeLabelAlert {
    
    [UIView animateWithDuration:2 animations:^{
        labelAlert.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [labelAlert removeFromSuperview];
    }];
    
}

- (void) removeButtonAndDatePicker {
    
    [UIView animateWithDuration:0.5 animations:^{
        doneButton.alpha = 0.0f;
        cancelButton.alpha = 0.0f;
        datePicker.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [doneButton removeFromSuperview];
        [cancelButton removeFromSuperview];
        [datePicker removeFromSuperview];
    }];
}









@end
