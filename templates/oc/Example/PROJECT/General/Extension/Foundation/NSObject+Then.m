//
//  NSObject+Then.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "NSObject+Then.h"


@implementation NSObject (Then)

+ (instancetype)instantiate:(void (^)(id _Nonnull))work {
    id instance = [[self class] new];
    !work ?: work(instance);
    return instance;
}

- (instancetype)then:(void (^)(id _Nonnull))work {
    !work ?: work(self);
    return self;
}

@end
