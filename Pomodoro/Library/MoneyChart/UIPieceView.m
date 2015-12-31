//
//  UIPieceView.m
//  MoneyChart
//
//  Created by Viet Bui on 12/4/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import "UIPieceView.h"
#import "UIPieChartView.h"

@implementation UIPieceView{
    CGFloat _distance;
    int _position;
}

-(id)initWithFrame:(CGRect)frame drawConfig:(DrawConfig *)drawConfig DataItem:(DataItem *)dataItem Position:(int)position{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor clearColor]];
        _needDrawLegendImage = false;
        _draw_config = drawConfig;
        _data_item = dataItem;
        _position = position;
//        self.hidden = true;
    }
    return self;
}

- (void)setAnimated:(BOOL)animated {
    _animated = animated;
    if (animated) {
        self.hidden = true;
    } else {
        self.hidden = false;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@"Layout changed subview");
    _draw_config = [((UIPieChartView*) object) draw_config];
    _data_item = [[((UIPieChartView*) object) data_draw] objectAtIndex:_position];
    double delayInSeconds = .01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setNeedsDisplay];
    });
}
-(void)startAnimChart{
    if (_animated) {
        self.hidden =false;
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:.2 animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            [_delegateAnim onStartAnimation];
        }];
    }
}

- (void)drawRect:(CGRect)rect
{
    
    [self drawAngle];
    [self drawShadowAngle];
    [self drawLine];
    [self drawLegendImage];
//    [self drawLegendCirle];
    [self drawLegendTitle];
}

-(void) drawAngle{
        UIBezierPath* p =
        [UIBezierPath bezierPathWithArcCenter:_draw_config.point_center radius:_draw_config.radius_chart startAngle:[_data_item start_degree]  endAngle:[_data_item end_degree] clockwise:TRUE];
        [[_data_item color] setStroke];
        [p setLineWidth:_draw_config.width_chart];
        [p stroke];
}
-(void) drawLine{
    UIBezierPath* p = [UIBezierPath bezierPath];
    [p moveToPoint:CGPointMake(_data_item.startLine.x  ,_data_item.startLine.y)];
    [p addLineToPoint:CGPointMake(_data_item.endLine.x, _data_item.endLine.y)];
    [[_data_item color] setStroke];
    [p setLineWidth:1];
    [p stroke];
    
//    CGContextSetLineWidth(context, 1.0);
//    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
//    CGFloat components[] = {0.0, 0.0, 1.0, 1.0};
//    CGColorRef color = CGColorCreate(colorspace, components);
//    CGContextSetStrokeColorWithColor(context, color);
//    CGContextMoveToPoint(context, _data_item.startLine.x   , _data_item.startLine.y);
//    CGContextAddLineToPoint(context, _data_item.endLine.x  , _data_item.endLine.y);
//    CGContextStrokePath(context);
//    CGColorSpaceRelease(colorspace);
//    CGColorRelease(color);
}

-(void) drawShadowAngle{
    UIBezierPath* p =
    [UIBezierPath bezierPathWithArcCenter:_draw_config.point_center radius:_draw_config.radius_shadow startAngle:[_data_item start_degree]  endAngle:[_data_item end_degree] clockwise:TRUE];
    UIColor* color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [color setStroke];
    [p setLineWidth:_draw_config.width_shadow];
    [p stroke];
}

-(void)drawLegendImage{
    UIImage *legendImage = [_data_item icon];
    
    CGFloat x = _data_item.point_legend_image.x - _data_item.diameter_legend_image/2;
    CGFloat y = _data_item.point_legend_image.y - _data_item.diameter_legend_image/2;
    CGFloat s = _data_item.diameter_legend_image;
    
    
    CGRect rectImage = CGRectMake(x, y, s, s);
    [legendImage drawInRect:rectImage];
    
    
//    UIBezierPath* p =
//    [UIBezierPath bezierPathWithArcCenter:_data_item.point_legend_image radius:_data_item.diameter_legend_image/2 startAngle:0 endAngle:M_PI*2 clockwise:TRUE];
//    
//    UIColor* color = [_data_item color];
//    [color setStroke];
//    [p setLineWidth:1];
//    [p stroke];
}
-(void) drawLegendCirle{
    UIBezierPath* p =
    [UIBezierPath bezierPathWithArcCenter:_data_item.point_legend_title radius:_data_item.diameter_legend_title/2 startAngle:0 endAngle:M_PI*2 clockwise:TRUE];
    
    UIColor* color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [color setFill];
    [p setLineWidth:1];
    [p fill];
}

-(void)drawLegendTitle{
    CGFloat x,y;
    _distance = _data_item.diameter_legend_title/2 - _draw_config.size_of_legend_title.height/2;
    
    x = _data_item.point_legend_title.x - _draw_config.size_of_legend_title.width/2;
    y = _data_item.point_legend_title.y + ((_data_item.constY* _data_item.degree_sweep_center*_distance)/M_PI_2) - _draw_config.size_of_legend_title.height/2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[_data_item color] CGColor]);
    
    CGRect rect = CGRectMake(x, y, _draw_config.size_of_legend_title.width, _draw_config.size_of_legend_title.height);
    
    NSString* legend = [NSString stringWithFormat:@"%.0f%%",_data_item.percent];
    [legend drawInRect:rect withFont:[UIFont systemFontOfSize:_draw_config.font_size_legend_title] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    
//    UIBezierPath* rectangle = [UIBezierPath bezierPathWithRect:rect];
//     UIColor* color = [UIColor colorWithRed:134 green:0 blue:30 alpha:0.8];
//    [color setFill];
//    [rectangle fill];

}


-(void)onStartAnimation{
    [self startAnimChart];
}

@end
