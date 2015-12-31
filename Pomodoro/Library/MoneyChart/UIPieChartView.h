//
//  UIPieChartView.h
//  MoneyChart
//
//  Created by Viet Bui on 12/2/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawConfig.h"
#import "PieChartConfig.h"
#import "PTLayoutChange.h"
@interface UIPieChartView : UIView<PTLayoutChange>
@property(nonatomic) int layout_change;
@property(nonatomic) NSMutableArray* data_draw;
@property(nonatomic) DrawConfig* draw_config;
@property(nonatomic) PieChartConfig* chart_config;
@property(nonatomic) BOOL animated;
-(void) setChartConfig:(PieChartConfig *)chartConfig dataChart:(NSArray * )data;
-(void) resetData;
-(void) setAnimated:(BOOL)animated;
@end
