//
//  PieChartConfig.m
//  MoneyChart
//
//  Created by Viet Bui on 12/2/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import "PieChartConfig.h"

@implementation PieChartConfig
-(id) init{
    self = [super init];
    if(self){
        [self initDefault];
    }
    return  self;
}

-(void) initDefault{
    _font_size_legend = 12;
    _padding_bottom = 0;
    _padding_left= 0;
    _padding_right = 0;
    _padding_top = 0;
    _size_img_legend = 28;
}
@end
