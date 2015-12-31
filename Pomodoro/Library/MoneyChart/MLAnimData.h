//
//  MLAnimData.h
//  MoneyChart
//
//  Created by Viet Bui on 11/22/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLAnimData : NSObject

@property(nonatomic) CGPoint pointStartPositive;
@property(nonatomic) CGPoint pointEndPositive;

@property(nonatomic) CGPoint pointStartNegative;
@property(nonatomic) CGPoint pointEndNegative;

@property(nonatomic) float speedPositive;
@property(nonatomic) float speedNegative;

@property(nonatomic) BOOL needToDrawPositive;
@property(nonatomic) BOOL needToDrawNegative;

-(CGFloat) endPositiveY;
-(CGFloat) endNegativeY;
@end
