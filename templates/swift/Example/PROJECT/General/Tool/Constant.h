//
//  Constant.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 用于 暴露 用OC/C/C++实现的功能 给swift调用

FOUNDATION_EXTERN void OCBenchmark(void (^block)(void), void (^complete)(double ms));

FOUNDATION_EXTERN void OCCallSwiftTest(void);

NS_ASSUME_NONNULL_END
