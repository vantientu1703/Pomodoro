//
//  UIPieChartView.m
//  MoneyChart
//
//  Created by Viet Bui on 12/2/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import "UIPieChartView.h"
#import "math.h"
#import "DataItem.h"
#import "PieData.h"
#import "UIPieceView.h"

@implementation UIPieChartView{
    NSArray* _data;
    
    CGFloat _diameter_legend_image;
    CGFloat _diameter_legend_title;
    CGFloat _anpla_between_title_legend;
}
//
//-(void) setChart_config:(PieChartConfig *)pie_config{
//    _chart_config = pie_config;
//    [self initChartConfig];
//}



-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return  self;
}

-(void) setChartConfig:(PieChartConfig *)chartConfig dataChart:(NSArray * )data{
    _chart_config = chartConfig;
    _data = data;
    [self initConfig];
    [self addPieceChart];
}

-(void) initConfig{
    [self initChartConfig];
    [self initChartData];
    [self initLegend];
}

-(void)layoutChange{
    [self initConfig];
    self.layout_change ++;
}

-(void)resetData{
    _data = nil;
    _data_draw = nil;

    for (UIView *subView in self.subviews){
        if([subView isKindOfClass:[UIPieceView class]]){
            [self removeObserver:subView forKeyPath:@"layout_change"];
            [subView removeFromSuperview];
        }
    }
}

#pragma pragma-mark Tinh toan config de ve chart
-(void) initChartConfig{
    _draw_config = [[DrawConfig alloc] init];
    [_draw_config setFont_size_legend_title:_chart_config.font_size_legend];
    CGFloat top;
    if(self.frame.size.width < self.frame.size.height){
        _draw_config.s_square = self.frame.size.width;
        top = (self.frame.size.height - _draw_config.s_square)/2;
    }else{
        _draw_config.s_square = self.frame.size.height;
        top = (self.frame.size.width - _draw_config.s_square)/2;
    }
    _draw_config.point_top_left =  CGPointMake(0, top);
   
    CGSize size = [@"100%" sizeWithFont:[UIFont systemFontOfSize:_chart_config.font_size_legend]];
    //Tinh toan kich thuoc toi da cua chu
    _draw_config.size_of_legend_title = size;
    
    //Tinh toan do dai duong kinh title legend
    _draw_config.diameter_legend_title = _draw_config.s_square - 2*size.width;
    
    //Tinh toan do dai duong kinh cua hinh tron se chua title legend
    _diameter_legend_title = size.width;

    //Tinh toan ban kinh cua hinh tron ma legend title se di qua
    _draw_config.radius_lengend_title = _draw_config.s_square / 2 - _diameter_legend_title/2;
    
    
    
    //Tinh toan do dai duong kinh image legend
    _draw_config.diameter_legend_image = _draw_config.diameter_legend_title - _chart_config.size_img_legend*2;
    
    //Tinh toan duong kinh cua image legend
    _diameter_legend_image =(_draw_config.diameter_legend_title/2 - _draw_config.diameter_legend_image/2);
    
    
    
    //Tinh toan do dai ban kinh that cua image legend tinh tu tam cua hinh vuong
    _draw_config.radius_legend_image = _draw_config.diameter_legend_image/2 + _diameter_legend_image/2;
    
    //Tinh toan goc toi thieu giua 2 duong tron legend title
    _anpla_between_title_legend = asin(_chart_config.size_img_legend/ _draw_config.radius_legend_image);
//    CGFloat degree = (_anpla_between_title_legend) * (180.0 / M_PI);
//    NSLog(@"%f",degree);
    //Tinh toan do dai duong kinh ben ngoai chart
    _draw_config.diameter_chart =  ceil(_draw_config.diameter_legend_image/1.4);
    
    //Tinh toan do day cua duong ve chart.
    _draw_config.width_chart = ceil(_draw_config.diameter_chart/4);
    //Tinh toan ban kinh thuc te cua hinh tron
    _draw_config.radius_chart =(_draw_config.diameter_chart - _draw_config.diameter_chart/4)/2;
    //Tinh ban kinh cua shadow
    _draw_config.radius_shadow = _draw_config.diameter_chart/4+ _draw_config.diameter_chart/12 - _draw_config.diameter_chart/24;
    //Do day cua shadow bang 1/3 so voi do day cua chart
    _draw_config.width_shadow = _draw_config.width_chart/3;
    
    //Khoi tao diem o giua (center)
//    _draw_config.point_center = CGPointMake(_draw_config.point_top_left.x + _draw_config.s_square/2, _draw_config.point_top_left.y + _draw_config.s_square/2);
    CGFloat xCenter = self.frame.size.width/2;
    CGFloat yCenter = self.frame.size.height/2;
_draw_config.point_center = CGPointMake(xCenter, yCenter);
}

-(void) initChartData{
    //Sap xep theo giam dan
    NSSortDescriptor* sorter = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:NO];
    NSArray* sortDescriptors = @[sorter];
    NSArray* sortedArray = [_data sortedArrayUsingDescriptors:sortDescriptors];
    _data = [[NSArray alloc]initWithArray:sortedArray];
    [_data sortedArrayUsingDescriptors:@[sorter]];
    
    NSInteger n = [_data count];
    CGFloat total = 0;
    for (int i=0;i<n;i++) {
       PieData* item = [_data objectAtIndex:i];
        total += [item value];
    }
    
    //Tinh toan lay % cua tung data
    _data_draw = [[NSMutableArray alloc] init];
    float tpercent = 0;
    for (int i=0;i<n;i++) {
        PieData* item = [_data objectAtIndex:i];
        DataItem* data = [[DataItem alloc]init];
        CGFloat percent = floor(([item value]/total)*100);
        tpercent = tpercent + percent;
        
        [data setPercent:percent];
        [data setColor:[item color]];
        [data setIcon:[item icon]];
        
        [_data_draw addObject:data];
    }
    //Lam tron du lieu neu data bi thieu
    NSInteger percent_remain = 100 - tpercent;
    NSInteger last_index = n-1;
    while (percent_remain >0) {
       CGFloat percent =  [(DataItem*)[_data_draw objectAtIndex:last_index] percent];
        if(percent_remain < 1){
            percent+=percent_remain;
            percent_remain = 0;
        }else{
            percent++;
        }
        [(DataItem*)[_data_draw objectAtIndex:last_index] setPercent:percent];
        percent_remain--;
        last_index --;
    }
    
    //Tinh toan cung can ve . Goc bat dau. goc ket thuc
    CGFloat startDegree = 270;
    CGFloat endDegree;
    
    CGFloat startRadian;
    CGFloat endRadian;
    CGFloat sweep_radian;
    CGFloat sweep_degree;
    
    
    
    for(int i=0;i<n;i++){
        DataItem* item = [_data_draw objectAtIndex:i];
        if(n == 1){
            endDegree = 630;
            startDegree = 270;
            sweep_degree = 360;
        }
        else if(i == n-1){
            endDegree = 270;
            sweep_degree = 270-startDegree;
        }else{
            sweep_degree = 360 * [item percent]/100;
            endDegree =startDegree + sweep_degree;
            if(endDegree > 360){
                endDegree = endDegree - 360;
            }
        }
        
        //Convert degree > radian
        startRadian = (startDegree * 2 * M_PI)/360;
        endRadian = (endDegree * 2 * M_PI)/360;
        sweep_radian = (sweep_degree * 2 * M_PI)/360;
        
        [item setStart_degree:startRadian];
        [item setEnd_degree:endRadian];
        [item setSweep_degree:sweep_radian];
        [item initCenter_degree];
        startDegree = endDegree;
    }
    
    //Tinh toan so luong goc cua moi phan
}

-(void) initLegend{
   int n = [_data_draw count];
    double distanceX;
    double distanceY;
    
    double distanceTitleX;
    double distanceTitleY;
    
    double distanceStartLineX;
    double distanceStartLineY;
    
    double distanceEndLineX;
    double distanceEndLineY;
    
    CGPoint point_lengend_image;
    CGPoint point_lengend_title;
    CGPoint point_start_line;
    CGPoint point_end_line;
    
    double degree;
    double M_3PI2 = 3*M_PI/2;
    double _degree_legend;
    CGFloat distance_between_2_circle;
    int constY;
    CGFloat degree_sweep_center;
    int x,y;
    DataItem* lastItem;
    CGFloat extend_degree = 0;
    BOOL edit = false;
   for(int i=n-1;i>=0;i--){
       DataItem* item = [_data_draw objectAtIndex:i];
       [item setDiameter_legend_image:_diameter_legend_image];
       [item setDiameter_legend_title:_diameter_legend_title];
       _degree_legend = [item center_degeree];
       //Tu 270 den 180
       if( _degree_legend < M_3PI2 && _degree_legend >= M_PI){
           degree = (M_3PI2 - [item end_degree]) +[item sweep_degree]/2 + extend_degree;
           x = -1;
           y = -1;
           constY = 1;
           degree_sweep_center =  _degree_legend - M_PI;
           
       }else if(_degree_legend < M_PI && _degree_legend >= M_PI_2){
           degree = ([item start_degree] - M_PI_2) +[item sweep_degree]/2 - extend_degree;
           
           x = -1;
           y = 1;
           
           constY = -1;
           degree_sweep_center = M_PI - _degree_legend;

       } else if(_degree_legend < M_PI_2 && _degree_legend >= 0){
           degree = (M_PI_2 - [item end_degree] ) +[item sweep_degree]/2 + extend_degree;
           x = 1;
           y = 1;
           
           constY = -1;
           
           degree_sweep_center = _degree_legend- 0;
       }else{
           degree = [item sweep_degree]/2 - extend_degree;
           x = 1;
           y = -1;
           
           constY = 1;
           
           if(_degree_legend <0){
               degree_sweep_center = 0 - _degree_legend;
           }else{
               degree_sweep_center = 2*M_PI - _degree_legend;
           }
       }
       
       distanceX = sin(degree) * _draw_config.radius_legend_image;
       distanceY = cos(degree) * _draw_config.radius_legend_image;
       
       distanceEndLineX = sin(degree) * (_draw_config.radius_legend_image - _chart_config.size_img_legend/2);
       distanceEndLineY = cos(degree) * (_draw_config.radius_legend_image - _chart_config.size_img_legend/2);
       
       distanceTitleX = sin(degree) * _draw_config.radius_lengend_title;
       distanceTitleY = cos(degree) * _draw_config.radius_lengend_title;
       
       distanceStartLineX = sin(degree) * (_draw_config.radius_chart + _draw_config.width_chart/2);
       distanceStartLineY = cos(degree) * (_draw_config.radius_chart + _draw_config.width_chart/2);
       
       point_lengend_image = CGPointMake(_draw_config.point_center.x + x*distanceX, _draw_config.point_center.y + y*distanceY);
       
       point_end_line = CGPointMake(_draw_config.point_center.x + x*distanceEndLineX, _draw_config.point_center.y + y*distanceEndLineY);
       
       if(!edit){
           point_start_line = CGPointMake(_draw_config.point_center.x + x*distanceStartLineX, _draw_config.point_center.y + y*distanceStartLineY);
           [item setStartLine:point_start_line];
       }
       
       if (lastItem) {
           distance_between_2_circle = sqrt( pow((point_lengend_image.x - lastItem.point_legend_image.x),2.0) + pow((point_lengend_image.y - lastItem.point_legend_image.y),2.0));

           if (distance_between_2_circle < _diameter_legend_image) {
               CGFloat new_degree_legend = lastItem.center_degeree - _anpla_between_title_legend;
               extend_degree = _degree_legend - new_degree_legend;
               [item setCenter_degeree:new_degree_legend];
               [_data_draw replaceObjectAtIndex:i withObject:item];
               i++;
               item = nil;
               edit = true;
               continue;
           }else{
               extend_degree = 0;
               edit = false;
           }
       }
       
       
       point_lengend_title = CGPointMake(_draw_config.point_center.x + x*distanceTitleX, _draw_config.point_center.y + y*distanceTitleY);
       
       [item setPoint_legend_image:point_lengend_image];
       [item setPoint_legend_title:point_lengend_title];
       [item setConstY:constY];
       [item setDegree_sweep_center:degree_sweep_center];
       [item setEndLine:point_end_line];
       
       lastItem = item;
       edit = false;
   }
}

-(void) addPieceChart{
    CGRect frameChild = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIPieceView* lastPiece;
    for (int i=0,n=(int) [_data_draw count]; i<n; i++) {
        DataItem* item = [_data_draw objectAtIndex:i];
        UIPieceView* currentPiece = [[UIPieceView alloc] initWithFrame:frameChild drawConfig:_draw_config DataItem:item Position:i];
        [currentPiece setAnimated:_animated];
        currentPiece.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [currentPiece setNeedDrawLegendImage:TRUE];
        [self addObserver:currentPiece forKeyPath:@"layout_change" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self addSubview:currentPiece];
        if(lastPiece){
            [lastPiece setDelegateAnim:currentPiece];
        }
        lastPiece = currentPiece;
    }    
    UIPieceView* first = [[self subviews] objectAtIndex:0];
    [first startAnimChart];
}
#pragma pragma-mark Ve bieu do tron
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    UIBezierPath* p =
//    [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 150) radius:100 startAngle:3*M_PI/2  endAngle:3*M_PI clockwise:TRUE];
//    [[UIColor blueColor] setStroke];
//    [p setLineWidth:10];
//    [p stroke];
    
//    [self drawBoundOutSideLegendRect];
//    [self drawBoundInsideLegendRect];
//    [self drawBoundInsideLegendImage];
//    [self drawBoundOutsideChart];
//    [self drawBoundRadiusLengendImage];
//    [self drawChart];
//    [self drawShadowCircle];
//}

-(void)drawBoundOutSideLegendRect{
    
    UIBezierPath* p1 = [UIBezierPath bezierPathWithRect:CGRectMake(_draw_config.point_top_left.x   , _draw_config.point_top_left.y, _draw_config.s_square, _draw_config.s_square)];
    [p1 setLineWidth:1];
    [[UIColor whiteColor] setStroke];
    [p1 stroke];
}

-(void)drawBoundInsideLegendRect{
    CGPoint pointInside = CGPointMake(_draw_config.point_center.x - _draw_config.diameter_legend_title/2, _draw_config.point_center.y - _draw_config.diameter_legend_title/2 );
    UIBezierPath* p1 = [UIBezierPath bezierPathWithRect:CGRectMake(pointInside.x   , pointInside.y
, _draw_config.diameter_legend_title, _draw_config.diameter_legend_title)];
    [p1 setLineWidth:1];
    [[UIColor whiteColor] setStroke];
    [p1 stroke];
}

-(void)drawBoundInsideLegendImage{
     CGPoint pointInside = CGPointMake(_draw_config.point_center.x - _draw_config.diameter_legend_image/2, _draw_config.point_center.y - _draw_config.diameter_legend_image/2 );
    
    UIBezierPath* p1 = [UIBezierPath bezierPathWithRect:CGRectMake(pointInside.x   , pointInside.y
                                                                   , _draw_config.diameter_legend_image, _draw_config.diameter_legend_image)];
    [p1 setLineWidth:1];
    [[UIColor greenColor] setStroke];
    [p1 stroke];
}

-(void)drawBoundOutsideChart{
    CGPoint pointInside = CGPointMake(_draw_config.point_center.x - _draw_config.diameter_chart/2, _draw_config.point_center.y - _draw_config.diameter_chart/2 );
    
    UIBezierPath* p1 = [UIBezierPath bezierPathWithRect:CGRectMake(pointInside.x   , pointInside.y
                                                                   , _draw_config.diameter_chart, _draw_config.diameter_chart)];
    [p1 setLineWidth:1];
    [[UIColor grayColor] setStroke];
    [p1 stroke];
}
-(void)drawBoundRadiusLengendImage{
    CGPoint pointInside = CGPointMake(_draw_config.point_center.x - _draw_config.radius_lengend_title, _draw_config.point_center.y - _draw_config.radius_lengend_title );
    UIBezierPath* p1 = [UIBezierPath bezierPathWithRect:CGRectMake(pointInside.x   , pointInside.y
                                                                   , _draw_config.radius_lengend_title*2, _draw_config.radius_lengend_title*2)];
    [p1 setLineWidth:1];
    [[UIColor yellowColor] setStroke];
    [p1 stroke];
}
/*
-(void) drawChart{
    for (int i=0,n=(int) [_data_draw count]; i<n; i++) {
        DataItem* item = [_data_draw objectAtIndex:i];
        UIBezierPath* p =
        [UIBezierPath bezierPathWithArcCenter:_draw_config.point_center radius:_draw_config.radius_chart startAngle:[item start_degree]  endAngle:[item end_degree] clockwise:TRUE];
        [[item color] setStroke];
        [p setLineWidth:_draw_config.width_chart];
        [p stroke];
    }
}

-(void) drawShadowCircle{
    UIBezierPath* p =
    [UIBezierPath bezierPathWithArcCenter:_draw_config.point_center radius:_draw_config.radius_shadow startAngle:0  endAngle:2*M_PI clockwise:TRUE];
    UIColor* color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [color setStroke];
    [p setLineWidth:_draw_config.width_shadow];
    [p stroke];
}
*/

- (void)dealloc {
    [self resetData];
}
@end
