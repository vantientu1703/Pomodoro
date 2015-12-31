//
//  PieData.h
//  MoneyChart
//
//  Created by Viet Bui on 12/3/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PieData : NSObject
@property CGFloat value;
@property UIImage* icon;
@property UIColor* color;
-(id)initWithValue:(CGFloat)value icon:(UIImage* )icon color:(UIColor* ) color;
@end
