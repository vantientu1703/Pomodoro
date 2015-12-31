//
//  MLColumnData.m
//  MoneyChart
//
//  Created by Viet Bui on 11/21/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import "MLColumnData.h"

@implementation MLColumnData

-(id)initWithTitle:(NSString*)title :(double)positiveValue :(double)negativeValue :(NSString *)extTitle{
    self = [super init];
    if(self){
        _title = title;
        _positiveValue = positiveValue;
        _negativeValue = negativeValue;
        _netValue = _positiveValue + _negativeValue;
        _extendTitle = extTitle;
    }
    return self;
}

- (void)setPositiveValue:(double)positiveValue {
    _positiveValue = positiveValue;
    _netValue = _positiveValue + _negativeValue;
}

- (void)setNegativeValue:(double)negativeValue {
    _negativeValue = negativeValue;
    _netValue = _positiveValue + _negativeValue;
}

@end
