//
//  UpdateProjectManageItemToDatabaseTask.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/26/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "UpdateProjectManageItemToDatabaseTask.h"
#import "DBUtil.h"

@implementation UpdateProjectManageItemToDatabaseTask
{
    ProjectManageItem *_projectManageItem;
}
- (instancetype) initWithProjectManageItem:(ProjectManageItem *)project {
    self = [super init];
    if (self) {
        _projectManageItem = project;
    }
    return self;
}

- (void) doQuery:(MoneyDBController *)_moneyDBCotroller {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:[NSString stringWithFormat:@"%ld", _projectManageItem.projectID]];
    
    NSInteger i = [_moneyDBCotroller update:projectmanage data:[DBUtil projectManageItemToDBItem:_projectManageItem] whereClause:@"projectid = ?" whereArgs:arr];
    
    if ((i != -1)) {
        
        DebugLog(@"Update database accessesfully");
    } else {
        
        DebugLog(@"Update not query");
    }
}
@end
