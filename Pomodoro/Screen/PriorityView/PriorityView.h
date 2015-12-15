//
//  PriorityView.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 12/8/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PriorityViewDelegate

- (void) priorityHight;
- (void) priorityMedium;
- (void) priorityLow;

@end

@interface PriorityView : UIView

@property (nonatomic, strong) id<PriorityViewDelegate> delegate;

- (instancetype) initWithFrame:(CGRect)frame;
@end
