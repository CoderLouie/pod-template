//
//  Constant.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN void OCBenchmark(void (^block)(void), void (^complete)(double ms));

FOUNDATION_EXTERN void OCCallSwift(void);

NS_ASSUME_NONNULL_END
