//
//  AddProjectViewController.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectManageItem.h"
@protocol AddProjectManagerDelegate <NSObject>

- (void) updateInfomationProject: (ProjectManageItem *) projectManagerItem;

@end

@interface AddProjectViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtProjectname;

@property (weak, nonatomic) IBOutlet UIButton *selectDateBtn;

@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

@property (nonatomic, strong) NSString *stringTitle;

@property (nonatomic, strong) ProjectManageItem *projectManageItem;
@property (nonatomic, strong) id<AddProjectManagerDelegate> delegate;

@end
