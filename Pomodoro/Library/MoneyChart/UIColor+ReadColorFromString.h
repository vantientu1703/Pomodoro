//
//  UIColor+ReadColorFromString.h
//  MoneyChart
//
//  Created by Viet Bui on 11/21/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ReadColorFromString)
+(UIColor *)colorFromHexString:(NSString *)hexString;
@end
