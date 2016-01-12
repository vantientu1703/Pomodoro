//
//  SoundListViewController.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 1/12/16.
//  Copyright © 2016 ZooStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SoundListViewControllerDelegate <NSObject>

- (void) selectJingtone: (int) jingtoneID;

@end
@interface SoundListViewController : UIViewController
@property (nonatomic, strong) id<SoundListViewControllerDelegate> delegate;
@end
