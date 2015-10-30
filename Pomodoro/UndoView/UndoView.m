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
    
    self.backgroundColor = [UIColor colorWithRed:175.0f/255.0f green:177.0f/255.0f blue:174.0f/255.0f alpha:1.0f];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.bounds.size.width * 3 / 5, 30)];
    label.text = @"Tasks is deleted";
    label.center = CGPointMake(self.bounds.size.width * 1 / 3 + 5 , self.bounds.size.height / 2);
    
    UIButton *undoButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width * 2 / 3, 5, self.bounds.size.width * 2 / 5 - 10, 30)];
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Undo"];
    
    [titleString addAttribute:NSUnderlineColorAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
    UIColor *txtColor= [UIColor redColor];
    [titleString setAttributes:@{NSForegroundColorAttributeName:txtColor,NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0, [titleString length])];
    [undoButton setAttributedTitle:titleString forState:normal];
    //[undoButton setTitle:@"Undo" forState:normal];
    undoButton.center = CGPointMake(self.bounds.size.width * 4 / 5 - 5, self.bounds.size.height / 2);
    [undoButton setTitleColor:[UIColor redColor] forState:normal];
    
    UIButton *exitButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 21, 5, 15, 15)];
    [exitButton setTitle:@"x" forState:normal];
    [exitButton setTitleColor:[UIColor whiteColor] forState:normal];    
    exitButton.backgroundColor = [UIColor grayColor];
    exitButton.layer.cornerRadius = 2;
    [self addSubview:exitButton];
    [self addSubview:label];
    [self addSubview:undoButton];
    
    [undoButton addTarget:self action:@selector(undoOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [exitButton addTarget:self action:@selector(removeUndoView) forControlEvents:UIControlEventTouchUpInside];
}
- (void) removeUndoView {
    
    [_delegate removeUndoView];
}
- (void) undoOnClicked {
    
    [_delegate undoHandle];
}
@end
