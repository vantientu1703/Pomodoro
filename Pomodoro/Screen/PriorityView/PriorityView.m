//
//  PriorityView.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 12/8/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import "PriorityView.h"

@implementation PriorityView
{
    UIButton *redButton;
    UIButton *blueButton;
    UIButton *yellowButton;
    CGSize size;
}
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void) setupView {
    
    size = self.bounds.size;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, size.width / 4 - 15, 20)];
    label.text = @"Priority :";
    [self addSubview:label];
    
    redButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width / 4 - 15, 0, size.width / 4, 20)];
    redButton.center = CGPointMake(size.width * 3 /8 - 15, size.height / 2);
    [redButton setBackgroundColor:[UIColor redColor]];
    redButton.layer.cornerRadius = 5;
    [redButton addTarget:self action:@selector(redButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:redButton];
    
    blueButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width / 2 - 10, 0, size.width / 4, 20)];
    [blueButton setBackgroundColor:[UIColor blueColor]];
    blueButton.layer.cornerRadius = 5;
    blueButton.center = CGPointMake(size.width * 5 / 8 - 10, size.height / 2);
    [blueButton addTarget:self action:@selector(blueButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:blueButton];
    
    yellowButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width * 3 / 4 - 5, 0, size.width / 4, 20)];
    [yellowButton setBackgroundColor:[UIColor yellowColor]];
    yellowButton.layer.cornerRadius = 5;
    yellowButton.center = CGPointMake(size.width * 7 / 8 - 5, size.height / 2);
    [yellowButton addTarget:self action:@selector(yellowButtonOnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:yellowButton];
}

- (void) redButtonOnClicked {
    [_delegate priorityHight];
    [UIView animateWithDuration:0.5 animations:^{
        redButton.frame = CGRectMake(size.width / 4 - 15, 0, size.width / 4 + 4, 25);
        redButton.center = CGPointMake(size.width * 3 /8 - 15, size.height / 2);
        blueButton.frame = CGRectMake(size.width / 2 - 10, 0, size.width / 4, 20);
        blueButton.center = CGPointMake(size.width * 5 / 8 - 10, size.height / 2);
        yellowButton.frame = CGRectMake(size.width * 3 / 4 - 5, 0, size.width / 4, 20);
        yellowButton.center = CGPointMake(size.width * 7 / 8 - 5, size.height / 2);
    }];
}

- (void) blueButtonOnClicked {
    [_delegate priorityMedium];
    [UIView animateWithDuration:0.5 animations:^{
        redButton.frame = CGRectMake(size.width / 4 - 15, 0, size.width / 4 + 4, 20);
        redButton.center = CGPointMake(size.width * 3 /8 - 15, size.height / 2);
        blueButton.frame = CGRectMake(size.width / 2 - 10, 0, size.width / 4, 25);
        blueButton.center = CGPointMake(size.width * 5 / 8 - 10, size.height / 2);
        yellowButton.frame = CGRectMake(size.width * 3 / 4 - 5, 0, size.width / 4, 20);
        yellowButton.center = CGPointMake(size.width * 7 / 8 - 5, size.height / 2);
    }];
}

- (void) yellowButtonOnClicked {
    [_delegate priorityLow];
    [UIView animateWithDuration:0.5 animations:^{
        redButton.frame = CGRectMake(size.width / 4 - 15, 0, size.width / 4 + 4, 20);
        redButton.center = CGPointMake(size.width * 3 /8 - 15, size.height / 2);
        blueButton.frame = CGRectMake(size.width / 2 - 10, 0, size.width / 4, 20);
        blueButton.center = CGPointMake(size.width * 5 / 8 - 10, size.height / 2);
        yellowButton.frame = CGRectMake(size.width * 3 / 4 - 5, 0, size.width / 4, 25);
        yellowButton.center = CGPointMake(size.width * 7 / 8 - 5, size.height / 2);
    }];
}
@end
