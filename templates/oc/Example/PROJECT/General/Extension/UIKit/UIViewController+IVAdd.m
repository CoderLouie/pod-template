//
//  UIViewController+IVAdd.m
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "UIViewController+IVAdd.h" 


@implementation UIViewController (IVAdd)

- (MASViewAttribute *)iv_safe_top {
    if (@available(iOS 11.0, *)) {
        return self.view.mas_safeAreaLayoutGuideTop;
    } else {
        // Fallback on earlier versions
        return self.mas_topLayoutGuideBottom;
    }
}

- (MASViewAttribute *)iv_safe_bottom {
    if (@available(iOS 11.0, *)) {
        return self.view.mas_safeAreaLayoutGuideBottom;
    } else {
        // Fallback on earlier versions
        return self.mas_bottomLayoutGuideTop;
    }
}

@end
