//
//  Singleton.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "Singleton.h"

 
@implementation Singleton

+ (instancetype)create {
    return [[[self class] alloc] init];
}
+ (instancetype)shared {
    static Singleton *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [self create];
    });
    return singleton;
}


- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}
@end


