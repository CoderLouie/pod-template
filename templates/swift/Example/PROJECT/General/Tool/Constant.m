//
//  Constant.m
//  PROJECT
//
//  Created by 李阳 on 2021/7/14.
//  Copyright © 2021 gomo. All rights reserved.
//

#import "Constant.h"

#import <sys/time.h>
 
void OCBenchmark(void (^block)(void), void (^complete)(double ms)) {
    // <sys/time.h> version
    struct timeval t0, t1;
    gettimeofday(&t0, NULL);
    block();
    gettimeofday(&t1, NULL);
    double ms = (double)(t1.tv_sec - t0.tv_sec) * 1e3 + (double)(t1.tv_usec - t0.tv_usec) * 1e-3;
    complete(ms);
}
