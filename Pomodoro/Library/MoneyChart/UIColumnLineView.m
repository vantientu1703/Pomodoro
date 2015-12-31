//
//  UIColumnLineView.m
//  MoneyChart
//
//  Created by Viet Bui on 11/22/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import "UIColumnLineView.h"
#import "ColumnChartConfig.h"
#import "MLColumnData.h"
#import "MLLineItem.h"

@implementation UIColumnLineView{
    CGFloat _oy;
    CGFloat _ox;
    CGFloat _originX;
    CGFloat _originY;
    NSMutableArray* _lines;
    int _totalNode;
    int _count;
    BOOL _isFirst;
}


-(id)initWithFrame:(CGRect)frame :(ColumnChartConfig *)chartConfig :(NSArray *)chartData{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _chartConfig = chartConfig;
        _chartData = chartData;
        [self initData];
    }
    return self;
}

-(void)setChartData:(NSArray *)chartData{
    _chartData = chartData;
    [self initData];
}

-(void) initData {
    _originX = _chartConfig.paddingLeft;
    _originY = self.frame.size.height;

    // Tinh toan toa. do 0x,0y
    _lines = [[NSMutableArray alloc] init];
    double distance = 0 - _chartConfig.startValueY;
    double numberOfStep = distance / _chartConfig.valueStep;
    _oy = (float) (_originY - (numberOfStep * _chartConfig.distanceYSeries) - _chartConfig.paddingBottom);
    _ox = _originX + _chartConfig.distanceXSeries / 2;
    int index = 1;
    int _timeAnimate = 30;
    for (MLColumnData* item in _chartData) {
        double netValue = [item netValue];
        float _endY;
        float _speed;
        float offsetX = index * _chartConfig.distanceXSeries
        - _chartConfig.distanceXSeries / 2 + _chartConfig.paddingLeft;//
        index++;
        int type;
        if (netValue > 0) {
            type = 1; //UP
            distance = netValue - _chartConfig.startValueY;
            numberOfStep = distance / _chartConfig.valueStep;
            _endY = (float) (_originY
                            - (numberOfStep * _chartConfig.distanceYSeries) - _chartConfig.paddingBottom);//
            _speed = (_oy - _endY) / _timeAnimate;
        } else {
            type = 2; //DOWN
            distance = 0 - netValue;
            numberOfStep = distance / _chartConfig.valueStep;
            _endY = (float) (_oy + (numberOfStep * _chartConfig.distanceYSeries));
            _speed = (_endY - _oy) / _timeAnimate;
        }
        MLLineItem* lineItem = [[MLLineItem alloc] init];
        [lineItem setOffsetX:offsetX];
        [lineItem setStartY:_oy];
        [lineItem setSpeed:_speed];
        [lineItem setEndY:_endY];
        [lineItem setType:type];
       
        [_lines addObject:lineItem];
    }
    _totalNode = [_lines count];
}

 - (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    _count = 0;
    _isFirst = TRUE;
    for (int i = 0, n = [_lines count]; i < n; i++) {
        MLLineItem* line = [_lines objectAtIndex:i];
        if([line hasMove] == FALSE){
            _count++;
        }
        if (_isFirst) {
            CGContextMoveToPoint(context, [line offsetX], [line getPoint]);
            _isFirst = false;
        } else {
            CGContextAddLineToPoint(context, [line offsetX], [line getPoint]);
        }
    }
    CGContextDrawPath(context, kCGPathStroke);
    
    if (_count != _totalNode) {
        [self reDraw];
    } else {
        //Draw circle
        
//        canvas.drawPath(path, paintLine);
        for (MLLineItem* columnLine in _lines) {
            CGRect circle = CGRectMake([columnLine offsetX]-4, [columnLine endY]-4, 8, 8);
           CGContextFillEllipseInRect(context, circle);

//            RectF oval = new RectF();
//            oval.left = columnLine.getX() - 8;
//            oval.right = columnLine.getX() + 8;
//            oval.top = columnLine.getEndY() - 8;
//            oval.bottom = columnLine.getEndY() + 8;
//            canvas.drawOval(oval, paintCircle);
        }
    }
}
-(void)reDraw{
    double delayInSeconds = .01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setNeedsDisplay];
    });
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    self.center = self.superview.center;
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
}

-(void)reUpdate{
    [self initData];
    [self setNeedsDisplay];
}

@end
