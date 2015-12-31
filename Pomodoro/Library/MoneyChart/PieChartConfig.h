//
//  PieChartConfig.h
//  MoneyChart
//
//  Created by Viet Bui on 12/2/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PieChartConfig : NSObject
@property(nonatomic) CGFloat font_size_legend;
@property(nonatomic) CGFloat padding_left;
@property(nonatomic) CGFloat padding_top;
@property(nonatomic) CGFloat padding_right;
@property(nonatomic) CGFloat padding_bottom;
@property(nonatomic) CGFloat size_img_legend;
@property(nonatomic) BOOL animated;
-(id) init;
@end
