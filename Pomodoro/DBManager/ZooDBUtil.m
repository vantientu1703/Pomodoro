//
//  ZooDBUtil.m
//  ZooCounted
//
//  Created by Pham Quang Thang on 3/16/13.
//  Copyright (c) 2013 ZooStudio. All rights reserved.
//

#import "ZooDBUtil.h"

@implementation ZooDBUtil

+ (NSString *)stringFromUTF8:(const char *)input {
    if (input == NULL) {
        return @"";
    } else {
        return [NSString stringWithUTF8String:input];
    }
}


@end
