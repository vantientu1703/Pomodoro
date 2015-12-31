
//
//  MLAnimData.m
//  MoneyChart
//
//  Created by Viet Bui on 11/22/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import "MLAnimData.h"

@implementation MLAnimData{
    CGFloat _offsetPositiveY;
    CGFloat _offsetNegativeY;
}

-(void)setPointStartPositive:(CGPoint)pointStartPositive{
    _pointStartPositive = pointStartPositive;
     _offsetPositiveY = _pointStartPositive.y;
    _offsetNegativeY = _pointStartPositive.y;
}

-(CGFloat)endNegativeY{
    if (_offsetNegativeY < self.pointEndNegative.y) {
        _needToDrawNegative = true;
        _offsetNegativeY += _speedNegative;
        if (_offsetNegativeY > self.pointEndNegative.y) {
            _offsetNegativeY = self.pointEndNegative.y;
        }
    }else{
        _needToDrawNegative = false;
    }
    return _offsetNegativeY;
}

-(CGFloat)endPositiveY{
    if (_offsetPositiveY > self.pointEndPositive.y) {
        _needToDrawPositive = true;
        _offsetPositiveY -= _speedPositive;
        if (_offsetPositiveY < self.pointEndPositive.y) {
            _offsetPositiveY = self.pointEndPositive.y;
        }
    }else{
        _needToDrawPositive = false;
    }
    return _offsetPositiveY;
}
@end
