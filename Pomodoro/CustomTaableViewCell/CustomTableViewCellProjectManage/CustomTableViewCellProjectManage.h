//
//  CustomTableViewCellProjectManage.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTableViewProjectManageDelegate

- (void) pushEditView: (NSIndexPath *) indexPath;

@end
@interface CustomTableViewCellProjectManage : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelProjectname;

@property (weak, nonatomic) IBOutlet UILabel *labelStartEndDateTime;

@property (weak, nonatomic) IBOutlet UILabel *labelTotalTodo;

@property (weak, nonatomic) IBOutlet UILabel *labelTotalDone;

@property (nonatomic, strong) id<CustomTableViewProjectManageDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIView *vieBackground;



@end
