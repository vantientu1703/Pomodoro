//
//  MenuAnimation.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 11/30/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuAnimationDelegate

- (void) closeMenuAnimation;

@end

@interface MenuAnimation : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id<MenuAnimationDelegate> delegate;
@end
