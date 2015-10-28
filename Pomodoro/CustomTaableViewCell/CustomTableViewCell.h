//
//  CustomTableViewCell.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/27/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *txtTask;

@property (weak, nonatomic) IBOutlet UILabel *date;

@end
