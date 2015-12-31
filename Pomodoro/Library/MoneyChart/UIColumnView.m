//
//  UIColumnView.m
//  MoneyChart
//
//  Created by Viet Bui on 11/21/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import "UIColumnView.h"
#import "ColumnChartConfig.h"
#import "MLAnimData.h"
#import "MLColumnData.h"

@implementation UIColumnView{
    CGFloat _originX;
    CGFloat _originY;
    NSMutableArray* columns;
    int _timeAnimate;
    CGFloat _widthColumn;
    int _numberColumn;
}

-(id) initWithFrame:(CGRect)frame :(NSArray *)dataChart :(ColumnChartConfig *)chartConfig{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setAlpha:0.5];
        [self setBackgroundColor:[UIColor clearColor]];
        columns = [[NSMutableArray alloc] init];
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleTopMargin;
        _timeAnimate = 30;
        _dataChart = dataChart;
        _chartConfig = chartConfig;
                [self initData];
    }
    return self;
}

-(void) initData {
    // Tinh toan toa. do 0x,0y
    _originX = _chartConfig.paddingLeft;
    _originY = self.frame.size.height;

    _widthColumn = _chartConfig.distanceXSeries * 0.6;
    double distance = 0 - _chartConfig.startValueY;
    double numberOfStep = distance / _chartConfig.valueStep;
    CGFloat _oy = _originY - (numberOfStep * _chartConfig.distanceYSeries) - _chartConfig.paddingBottom;
    NSLog(@"OY-COLUMN = %f",_oy);
//   CGFloat _ox = _originX + _chartConfig.distanceXSeries / 2;
    
    CGFloat _offsetEndPositiveY;
    CGFloat _offsetEndNegativeY;

    float _speedPositive;
    float _speedNegative;
    [columns removeAllObjects];
    for(int i=0,n=[_dataChart count] ;i <n;i++){
        // Lay ra toa do x,y cua vi tri duong.
        MLColumnData* data = [_dataChart objectAtIndex:i];
        distance = data.positiveValue - _chartConfig.startValueY;
        numberOfStep = distance / _chartConfig.valueStep;
        _offsetEndPositiveY = (float) (_originY
                          - (numberOfStep * _chartConfig.distanceYSeries) - _chartConfig.paddingBottom);//
       CGFloat _offsetStartX = i * _chartConfig.distanceXSeries  + _chartConfig.distanceXSeries /2+  _chartConfig.paddingLeft;//
        
        _speedPositive = (_oy - _offsetEndPositiveY) / _timeAnimate;
    
        // Lay ra toa do x,y cua vi tri am
        distance = 0 - data.negativeValue;
        numberOfStep = distance / _chartConfig.valueStep;
        _offsetEndNegativeY = (float) (_oy + (numberOfStep * _chartConfig.distanceYSeries));//
        _speedNegative = (_offsetEndNegativeY - _oy) / _timeAnimate;
        
        MLAnimData* animData = [[MLAnimData alloc] init];
        CGPoint start = {_offsetStartX ,_oy};
        CGPoint endPositive = {_offsetStartX,_offsetEndPositiveY};
        CGPoint endNegative = {_offsetStartX,_offsetEndNegativeY};
        [animData setPointStartPositive:start];
        [animData setPointEndPositive:endPositive];
        
        [animData setPointStartNegative:start];
        [animData setPointEndNegative:endNegative];
        [animData setSpeedNegative:_speedNegative];
        [animData setSpeedPositive:_speedPositive];
        
        [columns addObject:animData];
//        animData.offsetStartPositive = _offsetStartPositiveY;
//        animData.offsetEndPositive = _offsetEndPositiveY;
//        rectPositive = new RectF();
//        rectPositive.left = mPositiveX - widthColumn/2;
//        rectPositive.right = mPositiveX + widthColumn/2;
//        rectPositive.top = mPositiveY;
//        rectPositive.bottom = mNegativeY;
    }
    _numberColumn = [columns count];
    //        rectNegative = new RectF();
}

-(void) drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextClearRect(context,rect);
    CGContextSetLineWidth(context, _widthColumn);
    int total = 0;
    for(MLAnimData* data in columns){
        
        CGContextSetStrokeColorWithColor(context, [_chartConfig.colorPositive CGColor]);
        CGContextMoveToPoint(context, data.pointStartPositive.x, data.pointStartPositive.y);
        CGContextAddLineToPoint(context, data.pointEndPositive.x,[data endPositiveY]);
        CGContextDrawPath(context, kCGPathStroke);
        if([data needToDrawPositive] == FALSE){
            total ++;
        }
        
        CGContextSetStrokeColorWithColor(context, [_chartConfig.colorNegatvie CGColor]);
        CGContextMoveToPoint(context, data.pointStartPositive.x, data.pointStartPositive.y);
        CGContextAddLineToPoint(context, data.pointEndNegative.x,[data endNegativeY]);
        CGContextDrawPath(context, kCGPathStroke);
        
        if([data needToDrawNegative] == FALSE){
            total ++;
        }
    }
    
    if(total < _numberColumn * 2){
        [self animationColumn];
    }
}

-(void)animationColumn{
    double delayInSeconds = .005;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setNeedsDisplay];
    });
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    self.center = self.superview.center;
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
}
-(void) reUpdate{
    [self initData];
}
@end
