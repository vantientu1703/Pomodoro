//
//  ResultsSearchTodoItemTableViewController.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 12/3/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "ResultsSearchTodoItemTableViewController.h"
#import "CustomTableViewCell.h"
@implementation ResultsSearchTodoItemTableViewController
{
    NSMutableArray *_arrTodoItems;
    UITableView *_tableView;
}
- (instancetype) initWithArrDatas:(NSMutableArray *)arrTodoItems wihtFrame:(CGRect)rect {
    self = [super initWithFrame:rect];
    if (self) {
        _arrTodoItems = arrTodoItems;
        [self setupView];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    return self;
}

- (void) setupView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    [self addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrTodoItems.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    TodoItem *todoItem = [[TodoItem alloc] init];
    
    cell.textLabel.text = todoItem.content;
    return cell;
}
@end
