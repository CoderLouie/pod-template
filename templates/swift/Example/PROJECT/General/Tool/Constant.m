//
//  Constant.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "Constant.h"

#import <sys/time.h>
 
void OCBenchmark(void (^block)(void), void (^complete)(double ms)) {
    // <sys/time.h> version
    
#if DEVELOPMENT
    NSLog(@"");
#else
    NSLog(@"");
#endif
    
    struct timeval t0, t1;
    gettimeofday(&t0, NULL);
    block();
    gettimeofday(&t1, NULL);
    double ms = (double)(t1.tv_sec - t0.tv_sec) * 1e3 + (double)(t1.tv_usec - t0.tv_usec) * 1e-3;
    complete(ms);
}

#import "OC_Call_Swift.h"

void OCCallSwift() {
    Car *c = [[Car alloc] initWithPrice:10.5 band:@"BMW"];

    c.band = @"Bently";

    c.price = 108.5;

    [c run]; // 108.5 Bently run
    [c test]; // 108.5 Bently test
    [Car run]; // Car run
}
