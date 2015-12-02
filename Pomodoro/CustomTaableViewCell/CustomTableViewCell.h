//
//  CustomTableViewCell.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/27/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "EditableTableController.h"

@interface CustomTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UITextField *txtTask;

@property (weak, nonatomic) IBOutlet UILabel *date;

@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet UILabel *labelPomodoros;


@end
