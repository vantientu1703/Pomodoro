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


@interface DetailProjectManageViewController ()
@property (nonatomic, strong) MoneyDBController *moneyDBController;
@end

@implementation DetailProjectManageViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = _projectManageItem.projectName;
    _segumnentedControl.selectedSegmentIndex = -1;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(backProjectManageViewController)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _moneyDBController = [MoneyDBController getInstance];
}

- (IBAction)selectSegumented:(id)sender {
    switch (_segumnentedControl.selectedSegmentIndex) {
        case 0:
        {
            AddProjectViewController *addProjectViewController = [[AddProjectViewController alloc] init];
            addProjectViewController.stringTitle = @"edit";
            addProjectViewController.projectManageItem = _projectManageItem;
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
