//
//  ColumnChartConfig.h
//  MoneyChart
//
//  Created by Viet Bui on 11/21/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColumnChartConfig : NSObject
@property(nonatomic) float paddingLeft;
@property(nonatomic) float paddingTop;
@property(nonatomic) float paddingRight;
@property(nonatomic) float paddingBottom;

@property(nonatomic) UIColor* colorXAxis;
@property(nonatomic) UIColor* colorYAxis;

@property(nonatomic) UIColor* colorXSeries;
@property(nonatomic) UIColor* colorYSeries;

@property(nonatomic) UIColor* colorPositive;
@property(nonatomic) UIColor* colorNegatvie;
@property(nonatomic) UIColor* colorNetValue;

@property(nonatomic) float fontSizeXSeries;
@property(nonatomic) float fontSizeYSeries;

@property(nonatomic) UIColor* colorLineBackground;

//Typeface fontFaceSeriesX;
//Typeface fontFaceSeriesY;
@property(nonatomic) int stepY;

@property(nonatomic) float widthHorizontentLine;

// Variable for draw
@property(nonatomic) float distanceYSeries;
@property(nonatomic) float distanceXSeries;

@property(nonatomic) int totalNodeX;
// int numberLine; // so luong line tren
@property(nonatomic) double valueStep; // Gia tri buoc nhay
@property(nonatomic) double startValueY; // Gia tri bat dau ve truc Y
@property(nonatomic) double lineMax;
@property(nonatomic) double lineMin;
@property(nonatomic) int numberLine;

@property(nonatomic) BOOL isShowLine;

-(void)resetData;

@end
