//
//  JingtoneItem.h
//  Pomodoro
//
//  Created by Văn Tiến Tú on 1/12/16.
//  Copyright © 2016 ZooStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JingtoneItem : NSObject

@property (nonatomic, strong) NSString *nameSong;
@property (nonatomic, strong) NSString *filePath;

- (instancetype) initWithNameSong: (NSString *) nameSong
                     withFilePath: (NSString *) filePath;
@end
