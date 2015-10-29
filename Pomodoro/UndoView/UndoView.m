//
//  UndoView.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/28/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "UndoView.h"

@implementation UndoView

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupView];
    }
    
    return self;
}

- (void) setupView {
    
    self.backgroundColor = [UIColor grayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.bounds.size.width * 3 / 5, 30)];
    label.text = @"Tasks is deleted";
    label.center = CGPointMake(self.bounds.size.width * 1 / 3 + 5 , self.bounds.size.height / 2);
    
    UIButton *undoButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width * 2 / 3 + 5, 5, self.bounds.size.width * 2 / 5 - 10, 30)];
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Undo"];
    
    [titleString addAttribute:NSUnderlineColorAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
    UIColor *txtColor= [UIColor redColor];
    [titleString setAttributes:@{NSForegroundColorAttributeName:txtColor,NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0, [titleString length])];
    [undoButton setAttributedTitle:titleString forState:normal];
    //[undoButton setTitle:@"Undo" forState:normal];
    undoButton.center = CGPointMake(self.bounds.size.width * 4 / 5 + 5, self.bounds.size.height / 2);
    [undoButton setTitleColor:[UIColor redColor] forState:normal];
    
    [self addSubview:label];
    [self addSubview:undoButton];
}
@end
