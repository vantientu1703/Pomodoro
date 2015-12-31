//
//  UIColumnView.h
//  MoneyChart
//
//  Created by Viet Bui on 11/21/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ColumnChartConfig;

@interface UIColumnView : UIView
@property(nonatomic) NSArray* dataChart;
@property(nonatomic) ColumnChartConfig* chartConfig;
- (id)initWithFrame:(CGRect)frame :(NSArray*)dataChart :(ColumnChartConfig*)chartConfig;
- (void) reUpdate;

@end
