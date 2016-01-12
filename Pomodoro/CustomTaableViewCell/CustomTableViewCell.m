//
//  CustomTableViewCell.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/27/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "UIColor+Extend.h"
@implementation CustomTableViewCell 

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(beingMovedCell:)];
    [self addGestureRecognizer:longPress];
    // Configure the view for the selected state
    self.backgroundColor = [[UIColor alloc] initWithHex:COLOR_LIGHT_PINK alpha:1.0f];
}

- (void) beingMovedCell: (UILongPressGestureRecognizer *) longPress {
    
}
@end
