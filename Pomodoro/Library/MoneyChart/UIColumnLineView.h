//
//  UIColumnLineView.h
//  MoneyChart
//
//  Created by Viet Bui on 11/22/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ColumnChartConfig;
@class MLColumnData;

@interface UIColumnLineView : UIView
@property(nonatomic)ColumnChartConfig* chartConfig;
@property(nonatomic)NSArray* chartData;

-(id)initWithFrame:(CGRect)frame :(ColumnChartConfig* )chartConfig :(NSArray*)chartData;
-(void)reUpdate;
@end
