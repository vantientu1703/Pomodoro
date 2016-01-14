//
//  DataSoundManager.m
//  Pomodoro
//
//  Created by Văn Tiến Tú on 1/15/16.
//  Copyright © 2016 ZooStudio. All rights reserved.
//

#import "DataSoundManager.h"
#import "JingtoneItem.h"
@implementation DataSoundManager

+ (instancetype) getSingleton {
    static DataSoundManager *dataManager = nil;
    static dispatch_once_t disPathOnce;
    dispatch_once(&disPathOnce, ^{
        dataManager = [self new];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SoundList" ofType:@"plist"];
        NSArray *raw = [NSArray arrayWithContentsOfFile:filePath];
        NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:raw.count];
        for (NSDictionary *item in raw) {
            
            JingtoneItem *jingtoneItem = [[JingtoneItem alloc] initWithNameSong:[item valueForKey:@"namesong"] withFilePath:[item valueForKey:@"filepath"]];
            [temp addObject:jingtoneItem];
            
        }
        dataManager.data = [NSArray arrayWithArray:temp];
    });
    
    return dataManager;
}
@end
