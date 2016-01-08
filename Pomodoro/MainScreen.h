//
//  ViewController.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/23/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainScreen : UIViewController

//@property (weak, nonatomic) IBOutlet UITextField *txtItemTodo;

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UITextField *txtItemTodo;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UISearchBar *searchBar;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardContraint;

@property (strong, nonatomic) UILabel *labelProjectname;


@end

