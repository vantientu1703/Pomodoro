
//
//  PieData.m
//  MoneyChart
//
//  Created by Viet Bui on 12/3/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import "PieData.h"

@implementation PieData
-(id)initWithValue:(CGFloat)value icon:(UIImage *)icon color:(UIColor *)color{
    self = [super init];
    if (self) {
        _value = value;
        _icon = icon;
        _color = color;
    }
    return  self;
}
@end
