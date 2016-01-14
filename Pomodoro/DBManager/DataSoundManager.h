//
//  DataSoundManager.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 1/15/16.
//  Copyright © 2016 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSoundManager : NSObject

@property (nonatomic, strong) NSArray *data;

+ (instancetype) getSingleton;
@end
