//
//  DrawConfig.h
//  MoneyChart
//
//  Created by Viet Bui on 12/2/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawConfig : NSObject
@property(nonatomic) CGFloat s_square; //Do dai cua hinh vuong
@property(nonatomic) CGSize size_of_legend_title;
@property(nonatomic) CGFloat radius_legend;
@property(nonatomic) CGFloat radius_chart;
@property(nonatomic) CGFloat radius_shadow;
@property(nonatomic) CGFloat radius_legend_image;
@property(nonatomic) CGFloat radius_lengend_title;

@property(nonatomic) CGPoint point_top_left;
@property(nonatomic) CGPoint point_center;

@property(nonatomic) CGFloat diameter_legend_title; //Do dai duong kinh (tiep xuc trong)
@property(nonatomic) CGFloat diameter_legend_image; //Do dai duong kinh (tiep xuc trong)
@property(nonatomic) CGFloat diameter_chart; //Duong kinh cua chart
@property(nonatomic) CGFloat width_chart; //Do day cua cung chart.
@property(nonatomic) CGFloat width_shadow; //Do day cua shadow.
@property(nonatomic) CGFloat font_size_legend_title;
@end
