//
//  JingtoneItem.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 1/12/16.
//  Copyright © 2016 ZooStudio. All rights reserved.
//

#import "JingtoneItem.h"

@implementation JingtoneItem

- (instancetype) initWithNameSong:(NSString *)nameSong withFilePath:(NSString *)filePath {
    if (self = [super init]) {
        self.nameSong = nameSong;
        self.filePath = filePath;
    }
    return self;
}
@end
