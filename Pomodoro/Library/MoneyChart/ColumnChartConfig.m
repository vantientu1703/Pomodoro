//
//  ColumnChartConfig.m
//  MoneyChart
//
//  Created by Viet Bui on 11/21/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import "ColumnChartConfig.h"
#import "UIColor+ReadColorFromString.h"

@implementation ColumnChartConfig{
    float _paddingBottom;
    float _paddingLeft;
    float _paddingRight;
    float _paddingTop;
    
    UIColor* _colorXAxis;
    UIColor* _colorYAxis;
    
    UIColor* _colorXSeries;
    UIColor* _colorYSeries;
    
    UIColor* _colorPositive;
    UIColor* _colorNegative;
    
    float _fontSizeXSeries;
    float _fontSizeYSeries;
    
    UIColor* _colorLineBackground;
    
    int _stepY;
    float _distanceXSeries;
    float _distanceYSeries;
    int _totalNodeX;
    double _valueStep;
    double _startValueY;
    double _lineMax;
    double _lineMin;
    int _numberLine;
    
}

@synthesize paddingBottom = _paddingBottom;
@synthesize paddingLeft = _paddingLeft;
@synthesize paddingRight = _paddingRight;
@synthesize paddingTop = _paddingTop;
@synthesize colorXAxis = _colorXAxis;
@synthesize colorYAxis = _colorYAxis;
@synthesize colorXSeries = _colorXSeries;
@synthesize colorYSeries = _colorYSeries;
@synthesize colorPositive = _colorPositive;
@synthesize colorNegatvie = _colorNegative;
@synthesize fontSizeXSeries = _fontSizeXSeries;
@synthesize fontSizeYSeries = _fontSizeYSeries;
@synthesize colorLineBackground = _colorLineBackground;
@synthesize stepY = _stepY;

@synthesize distanceXSeries = _distanceXSeries;
@synthesize distanceYSeries = _distanceYSeries;
@synthesize totalNodeX = _totalNodeX;
@synthesize valueStep = _valueStep;
@synthesize startValueY = _startValueY;
@synthesize lineMax = _lineMax;
@synthesize lineMin = _lineMin;
@synthesize numberLine = _numberLine;

-(void) initDefaultConfig{
    _paddingLeft = 0;
    _paddingRight = 0;
    _paddingTop = 0;
    _paddingBottom = 0;
    
    _colorXAxis = [UIColor colorFromHexString:@"#333333"];
    _colorYAxis = [UIColor colorFromHexString:@"#999999"];
    
    _colorLineBackground = [UIColor colorFromHexString:@"#3498CB"];
    
    _colorPositive =[UIColor colorFromHexString:@"#93C046"];
    _colorNegative = [UIColor colorFromHexString:@"#F0544D"];
    
    _colorXSeries = [UIColor redColor];
    _colorYSeries = [UIColor yellowColor];
    
    _fontSizeXSeries = 14;
    _fontSizeYSeries = 14;
    
    _stepY = 0;
    _distanceXSeries = 0;
    _distanceYSeries = 0;
    _totalNodeX = 0;
    _valueStep = 0;
    _startValueY = 0;
    _lineMax = 0;
    _lineMin = 0;
    _numberLine = 0;
    _isShowLine = NO;

}

-(id) init{
    self = [super init];
    if(self){
        [self initDefaultConfig];
    }
    return self;
}
-(void)resetData{
//    [self initDefaultConfig];
    _paddingLeft = 0;
    _paddingRight = 0;
    _paddingTop = 0;
    _paddingBottom = 0;
    
    _stepY = 0;
    _distanceXSeries = 0;
    _distanceYSeries = 0;
    _totalNodeX = 0;
    _valueStep = 0;
    _startValueY = 0;
    _lineMax = 0;
    _lineMin = 0;
    _numberLine = 0;
}
@end
