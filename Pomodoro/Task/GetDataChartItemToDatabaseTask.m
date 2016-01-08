//
//  GetDataChartItemToDatabaseTask.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 1/7/16.
//  Copyright © 2016 ZooStudio. All rights reserved.
//

#import "GetDataChartItemToDatabaseTask.h"

@implementation GetDataChartItemToDatabaseTask

- (NSMutableArray *) getDataChartItemToDatabase:(MoneyDBController *)_moneyDBController {
    
    NSString *query = @"SELECT * FROM datachart";
    
    NSArray *arr = [_moneyDBController rawQuery:query arg:nil];
    NSMutableArray *arrDataCharts = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dataChartDict in arr) {
        
        DataChartItem *dataChartItem = [[DataChartItem alloc] init];
        dataChartItem = [DBUtil dbItemToDataChartItem:dataChartDict];
        
        [arrDataCharts addObject:dataChartItem];
    }
    
    return arrDataCharts;
}
@end
