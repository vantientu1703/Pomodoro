//
//  MLLineItem.h
//  MoneyChart
//
//  Created by Viet Bui on 11/22/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLLineItem : NSObject

@property(nonatomic) CGFloat startY;
@property(nonatomic) CGFloat speed;
@property(nonatomic) CGFloat endY;
@property(nonatomic) CGFloat offsetX;
@property(nonatomic) int type;
-(BOOL) hasMove;
-(float) getPoint;
@end
