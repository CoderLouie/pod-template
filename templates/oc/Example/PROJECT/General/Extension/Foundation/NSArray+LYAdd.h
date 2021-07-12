//
//  NSArray+LYAdd.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ObjectType> (LYAdd)

- (void)each:(void (^)(ObjectType obj, NSUInteger idx))block;

- (NSArray *)map:(id _Nullable (^)(ObjectType obj, NSUInteger idx))block;

- (ObjectType)match:(BOOL (^)(ObjectType obj))block;

- (NSUInteger)filter:(BOOL (^)(ObjectType obj))block;
@end
NS_ASSUME_NONNULL_END
