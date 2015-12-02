//
//  DetailProjectManageViewController.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/27/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailProjectManageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segumnentedControl;

@property (nonatomic, strong) ProjectManageItem *projectManageItem;
@end
