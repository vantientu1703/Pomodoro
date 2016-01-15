//
//  SelectDeadlineViewController.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 1/15/16.
//  Copyright © 2016 ZooStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectManageItem.h"
@protocol SelectDeadlineViewControllerDelegate

- (void) selectedDate:(NSDate *) _datePicker;
@end

@interface SelectDeadlineViewController : UIViewController
@property (nonatomic, strong) id<SelectDeadlineViewControllerDelegate> delegate;
@property (nonatomic, strong) ProjectManageItem *projectManagerItem;
@property (nonatomic, strong) NSString *stringTitle;
@end
