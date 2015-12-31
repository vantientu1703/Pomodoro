//
//  DataItem.h
//  MoneyChart
//
//  Created by Viet Bui on 12/4/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataItem : NSObject
@property(nonatomic) CGFloat start_degree;
@property(nonatomic) CGFloat end_degree;
@property(nonatomic) CGFloat center_degeree;

@property(nonatomic) CGFloat sweep_degree;
@property(nonatomic) CGFloat degree;
@property(nonatomic) CGFloat percent;
@property(nonatomic) UIImage* icon;
//@property(nonatomic) NSString* percent_title;
@property(nonatomic) UIColor* color;
@property(nonatomic) CGPoint point_legend_image;
@property(nonatomic) CGFloat diameter_legend_image;

@property(nonatomic) CGPoint point_legend_title;
@property(nonatomic) CGFloat diameter_legend_title;
@property(nonatomic) int constY;
@property(nonatomic) CGFloat degree_sweep_center;

@property(nonatomic) CGPoint startLine;
@property(nonatomic) CGPoint endLine;
@property(nonatomic) CGFloat extend_degree;

-(void)initCenter_degree;
@end
