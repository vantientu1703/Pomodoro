//
//  ResultsSearchTodoItemTableViewController.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 12/3/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface ResultsSearchTodoItemTableViewController : UIView <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>

- (instancetype) initWithArrDatas: (NSMutableArray *) arrTodoItems wihtFrame: (CGRect) rect;
@end
