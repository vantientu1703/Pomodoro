//
//  MLColumnData.h
//  MoneyChart
//
//  Created by Viet Bui on 11/21/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLColumnData : NSObject

@property(nonatomic) double positiveValue;
@property(nonatomic) double negativeValue;
@property(nonatomic) double netValue;
@property(nonatomic) NSString* title;
@property(nonatomic) NSString* extendTitle;

-(id)initWithTitle:(NSString*)title :(double)positiveValue :(double)negativeValue :(NSString*) extTitle;

@end
