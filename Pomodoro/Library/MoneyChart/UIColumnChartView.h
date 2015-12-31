//
//  UIColumnChartView.h
//  MoneyChart
//
//  Created by Viet Bui on 11/20/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCAliasName.h"

@class ColumnChartConfig;

@interface UIColumnChartView : UIView
@property (nonatomic) BOOL touched;
@property (nonatomic) CGPoint locationOfTouch;
@property (nonatomic) NSArray* chart_data;
@property (nonatomic) int orientation_changed;
@property (nonatomic) id<PCAliasName> aliasNameDelegate;

-(void)setChartConfig:(ColumnChartConfig*)chartConfig;
-(void)setChart_data:(NSArray *)chart_data;
-(void)reConfigChart;
@end
