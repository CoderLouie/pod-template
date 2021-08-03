//
//  SwiftFitSizeOC.h
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#ifndef SwiftFitSizeOC_h
#define SwiftFitSizeOC_h

#define SF_Font(font) \
[[SwiftyFitsize shared] sf_font:font]

#define SF_Value(value) \
[[SwiftyFitsize shared] sf_float:value]

#define SafeInsetT \
[[SwiftyFitsize shared] sf_safeInsetT]

#define SafeInsetB \
[[SwiftyFitsize shared] sf_safeInsetB]
 
#define NavBarH \
[[SwiftyFitsize shared] sf_navbarH]

#define TabBarH \
[[SwiftyFitsize shared] sf_tabbarH]

#endif /* SwiftFitSizeOC_h */
