//
//  ViewController.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

//@property (weak, nonatomic) IBOutlet UITextField *txtItemTodo;

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UITextField *txtItemTodo;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

