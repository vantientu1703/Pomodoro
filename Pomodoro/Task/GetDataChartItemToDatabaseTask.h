//
//  GetDataChartItemToDatabaseTask.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 1/7/16.
//  Copyright © 2016 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataChartItem.h"

@interface GetDataChartItemToDatabaseTask : NSObject

- (NSMutableArray *) getDataChartItemToDatabase: (MoneyDBController *) _moneyDBController;
@end
