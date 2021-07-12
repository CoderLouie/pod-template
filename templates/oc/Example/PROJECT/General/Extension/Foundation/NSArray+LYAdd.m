//
//  NSArray+LYAdd.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "NSArray+LYAdd.h"


@implementation NSArray (LYAdd)

- (NSArray *)map:(id  _Nullable (^)(id _Nonnull, NSUInteger))block
{
    NSParameterAssert(block != nil);
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id value = block(obj, idx);
        if (value != nil) [result addObject:value];
    }];
    
    return result;
}

- (void)each:(void (^)(id _Nonnull, NSUInteger))block
{
    NSParameterAssert(block != nil);
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx);
    }];
}

- (id)match:(BOOL (^)(id _Nonnull))block
{
    NSParameterAssert(block != nil);
    
    NSUInteger index = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);
    }];
    
    if (index == NSNotFound) return nil;
        
    return self[index];
}

- (NSUInteger)filter:(BOOL (^)(id))block
{
    NSParameterAssert(block != nil);
    
    if (!self.count)
    {
        return NSNotFound;
    }
    
    return [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        BOOL flag = block(obj);
        if (flag)
        {
            *stop = YES;
        }
        return flag;
    }];
}

@end
