//
//  NSObject+Then.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Then)

+ (instancetype)instantiate:(void (^)(id me))work;

- (instancetype)then:(void (^)(id me))work; 

@end

NS_ASSUME_NONNULL_END
