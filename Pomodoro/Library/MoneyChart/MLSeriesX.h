//
//  MLSeriesX.h
//  MoneyChart
//
//  Created by Viet Bui on 11/21/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLSeriesX : NSObject
@property(nonatomic) NSString* title;
@property(nonatomic) NSString* exTitle;
@property(nonatomic) float width;
@property(nonatomic) float height;
@property(nonatomic) float padding;
@property(nonatomic) float centerX;
@property(nonatomic) float x;
@property(nonatomic) float y;
@property(nonatomic) CGSize sizeText;
@property(nonatomic) CGSize sizeExtendTitle;
@end
