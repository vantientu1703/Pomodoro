//
//  UndoView.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 10/28/15.
//  Copyright © 2015 ZooStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UndoViewDelegate

- (void) undoHandle;
- (void) removeUndoView;
@end

@interface UndoView : UIView

@property (nonatomic, strong)id<UndoViewDelegate> delegate;
@end
