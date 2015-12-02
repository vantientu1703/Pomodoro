//
//  CustomTableViewCellProjectManage.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "CustomTableViewCellProjectManage.h"
#import "AddProjectViewController.h"

@interface CustomTableViewCellProjectManage ()

@property (nonatomic, weak) UITableView *containningTableView;

@end

@implementation CustomTableViewCellProjectManage

- (void)awakeFromNib {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)editOnClicked:(id)sender {
    
    [_delegate pushEditView:_indexPath];
}
@end
