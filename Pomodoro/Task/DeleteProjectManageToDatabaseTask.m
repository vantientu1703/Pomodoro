//
//  DeleteProjectManageToDatabaseTask.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/27/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "DeleteProjectManageToDatabaseTask.h"

@implementation DeleteProjectManageToDatabaseTask
{
    ProjectManageItem *_projectManageItem;
}
- (instancetype) initWithProjectManage:(ProjectManageItem *)projectManageItem {
    self = [super init];
    if (self) {
        _projectManageItem = projectManageItem;
    }
    return self;
}

- (void) doQuery:(MoneyDBController *)_moneyDBController {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:[NSString stringWithFormat:@"%ld",_projectManageItem.projectID]];
    
    NSInteger i = [_moneyDBController delete:PROJECTMANAGE conditionString:@"projectid = ?" conditionValue:arr];
    if (i != -1) {
        DebugLog(@"Delete was execute successfully");
    } else {
        
        DebugLog(@"Not query to database");
    }

}
@end
