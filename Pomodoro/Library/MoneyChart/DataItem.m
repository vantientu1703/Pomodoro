//
//  DataItem.m
//  MoneyChart
//
//  Created by Viet Bui on 12/4/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import "DataItem.h"

@implementation DataItem
-(void)setPercent:(CGFloat)percent{
    _percent = percent;
    
}
-(void)initCenter_degree{
    _center_degeree = _end_degree - _sweep_degree/2;
}
@end
