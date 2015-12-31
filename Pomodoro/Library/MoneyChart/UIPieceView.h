//
//  UIPieceView.h
//  MoneyChart
//
//  Created by Viet Bui on 12/4/13.
//  Copyright (c) 2013 Viet Bui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawConfig.h"
#import "PieChartConfig.h"
#import "DataItem.h"
#import "PTAnimation.h"
#import "PTLayoutChange.h"
@interface UIPieceView : UIView <PTAnimation>{
    @private
    DrawConfig* _draw_config;
    DataItem* _data_item;

}

@property(nonatomic,assign) BOOL animated;

@property(nonatomic) id<PTAnimation> delegateAnim;
@property(nonatomic) BOOL needDrawLegendImage;

-(id)initWithFrame:(CGRect)frame drawConfig:(DrawConfig*)drawConfig DataItem:(DataItem *)dataItem Position:(int)position;
-(void) startAnimChart;
@end
