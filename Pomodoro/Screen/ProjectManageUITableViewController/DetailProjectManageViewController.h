//
//  DetailProjectManageViewController.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/27/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PCAliasName.h"

@interface DetailProjectManageViewController : UIViewController <PCAliasName>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segumnentedControl;

@property (nonatomic, strong) ProjectManageItem *projectManageItem;

@property (weak, nonatomic) IBOutlet UILabel *nameProject;
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UILabel *endDate;
@property (weak, nonatomic) IBOutlet UITextView *desscriptTextView;
@property (weak, nonatomic) IBOutlet UILabel *totalTodo;
@property (weak, nonatomic) IBOutlet UILabel *totalToDone;










@end
