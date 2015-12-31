//
//  UIColumnChartView.m
//  MoneyChart
//
//  Created by Viet Bui on 11/20/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import "UIColumnChartView.h"
#import "ColumnChartConfig.h"
#import "MLColumnData.h"
#import "math.h"
#import "MLSeriesX.h"
#import "MLSeriesY.h"
#import "UIColumnView.h"
#import "UIColumnLineView.h"
//#import "CommonStyles.h"

const int MAX_LINE = 12;

@implementation UIColumnChartView{
    BOOL isStop ;
    float _xOffset;
    float _yOffset;
    ColumnChartConfig* _chartConfig;
    double STEP[60];
    NSArray* _seriesX;
    NSArray* _seriesY;
    double _maxValue;
    double _minValue;
    double _valueStep;
    float _paddingRightSeriesY;
    float _originX;
	float _originY;
    UIColumnView* colView;
    UIColumnLineView* lineView;
    BOOL _is_first_time_draw_chart;
    
}
#pragma pragma-mark Khoi tao step cho chart
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        _is_first_time_draw_chart = TRUE;
        [self setBackgroundColor:[UIColor clearColor]];
        _paddingRightSeriesY = 5;
        [self initStep];
    }
    return self;
}

-(void)initStep{
    int i=0;
    double value1 = 1;
    double value2 = 2;
    double value3 = 5;
    
    for(i=0;i<60;i+=3){
        STEP[i] = value1;
        STEP[i+1] = value2;
        STEP[i+2]= value3;
        value1*=10;
        value2*=10;
        value3*=10;
    }
}

-(void)setChartConfig:(ColumnChartConfig *)chartConfig{
    _chartConfig = chartConfig;
}

#pragma pragma-mark Thiet lap du lieu cho chart va tinh toan gia tri can ve
-(void)setChart_data:(NSArray *)chart_data{
    _chart_data = chart_data;
//    [self genChartConfig];
}

#pragma pragma-mark Tinh toan cac gia tri ve chart
-(void) reConfigChart{
    [_chartConfig resetData];
    [self genChartConfig];
    
    [colView setChartConfig:_chartConfig];
    [colView setDataChart:_chart_data];
    [colView reUpdate];
    
    [lineView setChartConfig:_chartConfig];
    [lineView setChartData:_chart_data];
    
    [colView setNeedsDisplay];
    [lineView setNeedsDisplay];
    [self setNeedsDisplay];
}

-(void) genChartConfig{
    [self genMaxMin];
    [self genStepChart];
    [self genSeriesX];
    [self genSeriesY];
    [self genXOY];
    [self setUpChart];
}
-(void) setUpChart {
    float widthAxisY = self.frame.size.height - _chartConfig.paddingBottom - _chartConfig.paddingTop;
    _chartConfig.distanceYSeries = widthAxisY / _chartConfig.numberLine;
    _chartConfig.distanceXSeries = (self.frame.size.width - _chartConfig.paddingLeft - _chartConfig.paddingRight)
    / _chartConfig.totalNodeX;
}

-(void) genMaxMin{

    _maxValue = DBL_MIN;
    _minValue = DBL_MAX;
    
    double maxSeries;
    double minSeries;
    
    for (int i = 0, n = [_chart_data count]; i < n; i++) {
        MLColumnData* data = [_chart_data objectAtIndex:i];
        maxSeries = [data positiveValue];
        minSeries = [data negativeValue];
        if (_maxValue < maxSeries) {
            _maxValue = maxSeries;
        }
        if (_minValue > minSeries) {
            _minValue = minSeries;
        }
    }
}

-(void) genStepChart{
    double dataRange = _maxValue - _minValue;
    for (int i=0;i<60;i++) {
        if (dataRange / STEP[i] < MAX_LINE) {
            _valueStep = STEP[i];
            break;
        }
    }
    double floorMinValue = 0;
    int constant;
    if (_minValue != 0) {
        if (_minValue / _valueStep != 0.) {
            floorMinValue = _minValue - _valueStep;
            constant = (int) (floorMinValue / _valueStep);
            floorMinValue = constant * _valueStep;
        } else {
            floorMinValue = _minValue;
        }
    }
    
    _chartConfig.startValueY = floorMinValue;
    double _ceilMaxValue;
    if (_maxValue / _valueStep != 0.) {
        _ceilMaxValue = _maxValue + _valueStep;
    } else {
        _ceilMaxValue = _maxValue;
    }
    
    constant = (int) (_ceilMaxValue / _valueStep);
    _ceilMaxValue = constant * _valueStep;
    
    double dataMiddle = (_maxValue + _minValue) / 2;
    
    double value1 = _ceilMaxValue - dataMiddle;
    double value2 = dataMiddle - floorMinValue;

    double maxTemp = fmax(value1, value2);
    double lineMax = dataMiddle + maxTemp;
    double lineMin = dataMiddle - maxTemp;
    
    _chartConfig.lineMax = lineMax;
    _chartConfig.lineMin = lineMin;
    _chartConfig.numberLine = (int) ((lineMax - lineMin) / _valueStep) + 1;
    _chartConfig.valueStep = _valueStep;
}

-(void) genSeriesX{
    NSMutableArray* _rs_seriesX = [[NSMutableArray alloc] init];
    NSString* strValue;
    float paddingBottom = 0;
    _chartConfig.totalNodeX = [_chart_data count];
    for (int i = 0,n = [_chart_data count]; i < n; i++) {
        MLSeriesX* seriesX = [[MLSeriesX alloc] init];
        MLColumnData* _item = [_chart_data objectAtIndex:i];
        strValue = [_item title];
        CGSize size = [strValue sizeWithFont:[UIFont systemFontOfSize:_chartConfig.fontSizeXSeries]];
        CGSize exSize = [[_item extendTitle] sizeWithFont:[UIFont systemFontOfSize:_chartConfig.fontSizeXSeries]];
        
        [seriesX setSizeExtendTitle:exSize];
        [seriesX setExTitle:[_item extendTitle]];
        [seriesX setTitle:strValue];
        [seriesX setWidth:size.width];
        [seriesX setHeight:size.height];
        [seriesX setCenterX:size.width/2];
        [seriesX setSizeText:size];
        
        if(paddingBottom < size.height + exSize.height){
            paddingBottom = seriesX.height + exSize.height;
        }
        [_rs_seriesX addObject:seriesX];
    }
    _chartConfig.paddingBottom += paddingBottom;
    _seriesX = [[NSArray alloc] initWithArray:_rs_seriesX];
}

-(void) genSeriesY{
    NSMutableArray* _rs_seriesY = [[NSMutableArray alloc] init];
    double startStep = _chartConfig.startValueY;
    NSString* strStep;
   
    float paddingLeft = 0;
    
    for (int i = 0; i < _chartConfig.numberLine; i++) {
//        strStep = [NSString stringWithFormat:@"%.0f",startStep];
        if (_aliasNameDelegate != nil) {
            strStep = [_aliasNameDelegate onAliasName:startStep];
        }else{
            strStep = [NSString stringWithFormat:@"%.0f",startStep];
        }
        CGSize size = [strStep sizeWithFont:[UIFont systemFontOfSize:_chartConfig.fontSizeXSeries]];
        MLSeriesY* seriesY = [[MLSeriesY alloc] init];
        seriesY.title = strStep;
        seriesY.height = size.height;
        seriesY.width = size.width + _paddingRightSeriesY;
        seriesY.padding = seriesY.width - 1;
        if (paddingLeft < seriesY.width) {
            paddingLeft = seriesY.width;
        }
        [seriesY setSizeText:size];
        [_rs_seriesY addObject:seriesY];
        startStep += (int) _valueStep;
    }
    _chartConfig.paddingLeft += (float) ceil(paddingLeft);
    _seriesY = [[NSArray alloc] initWithArray:_rs_seriesY];
}

-(void)genXOY{
    _originX = _chartConfig.paddingLeft;
    _originY = self.frame.size.height - _chartConfig.paddingBottom;
}

#pragma pragma-mark : Ve chart

- (void)drawRect:(CGRect)rect
{
   [self drawLine];
    [self drawSeriesX];
    [self drawSeriesY];
    [self addColumnView];
}
-(void) drawLine{
    float offset = _originY;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [[_chartConfig colorLineBackground] CGColor]);
    CGContextSetLineWidth(context, .5f);
    
    for (int i = 0; i < _chartConfig.numberLine; i++) {
        
        CGContextMoveToPoint(context, _originX, offset);
        CGContextAddLineToPoint(context, self.frame.size.width - _chartConfig.paddingRight,offset);
        CGContextDrawPath(context, kCGPathStroke);
        offset -= _chartConfig.distanceYSeries;

    }
}

-(void) drawSeriesX{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [_chartConfig.colorXSeries CGColor]);
    CGFloat offsetX,offsetExtendX;
    CGFloat offsetY,offsetExtendY;
    CGRect iRect;
    CGRect exRect;
    offsetExtendY = 0;
    for (int i = _chartConfig.totalNodeX - 1; i >= 0; i--) {
        MLSeriesX* item = [_seriesX objectAtIndex:i];
        offsetX = _originX + i * _chartConfig.distanceXSeries + _chartConfig.paddingRight + _chartConfig.distanceXSeries /2 -item.width/2;
        offsetExtendX = _originX + i * _chartConfig.distanceXSeries + _chartConfig.paddingRight + _chartConfig.distanceXSeries /2 -item.sizeExtendTitle.width/2;
        offsetY = _originY;
        
        if (offsetExtendY ==0) {
            offsetExtendY = offsetY + item.height;
        }
        
        iRect =CGRectMake(offsetX, offsetY, item.sizeText.width+2, item.sizeText.height);
        exRect =CGRectMake(offsetExtendX, offsetExtendY, item.sizeExtendTitle.width + 5, item.sizeExtendTitle.height);
        
//       [item.title drawInRect:iRect withFont:[UIFont systemFontOfSize:_chartConfig.fontSizeXSeries] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        [item.title drawInRect:iRect withFont:[UIFont systemFontOfSize:_chartConfig.fontSizeXSeries] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        
//        [item.exTitle drawInRect:exRect withFont:[UIFont systemFontOfSize:_chartConfig.fontSizeXSeries] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        [item.exTitle drawInRect:exRect withFont:[UIFont systemFontOfSize:_chartConfig.fontSizeXSeries] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    }
}

-(void) drawSeriesY{
    float offset = _originY;
    float paddingSeriesY, heightSeriesY;
    CGFloat offsetX;
    CGFloat offsetY;
    CGRect iRect;
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, [_chartConfig.colorYSeries CGColor]);

    for (int i = 0; i < _chartConfig.numberLine; i++) {
        MLSeriesY* item = [_seriesY objectAtIndex:i];
        paddingSeriesY = item.padding;
        heightSeriesY = item.sizeText.height/2;
        offsetX = _originX - paddingSeriesY;
        offsetY = offset - heightSeriesY;
         iRect =CGRectMake(offsetX, offsetY, item.sizeText.width, item.sizeText.height);
        
//         [item.title drawInRect:iRect withFont:[UIFont systemFontOfSize:_chartConfig.fontSizeXSeries] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        [item.title drawInRect:iRect withFont:[UIFont systemFontOfSize: _chartConfig.fontSizeXSeries] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        
        offset -= _chartConfig.distanceYSeries;
    }
}

-(void) addColumnView{
    if(_is_first_time_draw_chart){
        _is_first_time_draw_chart = FALSE;
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        CGRect frameChild = self.frame;
        frameChild.origin.x = 0;
        frameChild.origin.y = 0;
        frameChild.size.width = self.frame.size.width;
        frameChild.size.height = self.frame.size.height;
        
         colView = [[UIColumnView alloc] initWithFrame:frameChild :_chart_data :_chartConfig];
        lineView = [[UIColumnLineView alloc] initWithFrame:frameChild :_chartConfig :_chart_data ];
        
//        lineView.center = self.center;
        lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
//        colView.center = self.center;
        colView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addObserver:colView forKeyPath:@"orientation_changed" options:0 context:nil];
        [self addObserver:lineView forKeyPath:@"orientation_changed" options:0 context:nil];
       
        [self addSubview:colView];
        lineView.hidden = YES;
        [self addSubview:lineView];
        
    });
    }
    
    if (_chartConfig.isShowLine) {
        lineView.hidden = NO;
    } else {
        lineView.hidden = YES;
    }
}

#pragma pragma-mark  Khi man hinh xoay se callback vao day de thong bao cho cac thanh phan khac cua chart ve lai
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath compare:@"pre_rotate"] == NSOrderedSame){
       
    }else if([keyPath compare:@"layout_changed"] == NSOrderedSame){
         [self reConfigChart];
        [colView reUpdate];
        [lineView reUpdate];
        
        [self setNeedsDisplay];
        [colView setNeedsDisplay];
    }
}


@end
