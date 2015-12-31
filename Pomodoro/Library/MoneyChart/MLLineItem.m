//
//  MLLineItem.m
//  MoneyChart
//
//  Created by Viet Bui on 11/22/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import "MLLineItem.h"

@implementation MLLineItem
const int UP = 1;
const int DOWN = 2;

-(BOOL) hasMove {
    if (_type == UP) {
        if (_startY > _endY) {
            return TRUE;
        } else {
            return FALSE;
        }
    } else {
        if (_startY < _endY) {
            return TRUE;
        } else {
            return FALSE;
        }
    }
}

-(float) getPoint{
    if (_type == UP) {
        _startY -= _speed;
        if (_startY < _endY) {
            _startY = _endY;
        }
    } else {
        _startY += _speed;
        if (_startY > _endY) {
            _startY = _endY;
        }
    }
    return _startY;
}
@end
