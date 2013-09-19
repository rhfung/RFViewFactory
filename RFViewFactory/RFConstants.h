//
//  RFConstants
//  RFViewFactory
//
//  Created by Richard H Fung on July 1, 2013 (Canada Day).
//  Copyright (c) 2013. All rights reserved.
//

// special SECTION that goes to the previously seen section and view
#define SECTION_LAST  @"__RFLastViewController__"

// built in VIEWs that can be overriden by the user
#define VIEW_BUILTIN_ERROR @"RFErrorViewController"
#define VIEW_BUILTIN_MAIN @"RFMainViewController"

#define VIEW_BUILTIN_ERROR_NIB @"RFDefaultErrorViewController"
#define VIEW_BUILTIN_MAIN_NIB @"RFDefaultMainViewController"

// open space in UIViewAnimationOptions
#define ANIMATION_NOTHING     0 << 9
#define ANIMATION_PUSH        1 << 10
#define ANIMATION_POP         1 << 11

// iOS 5 support
#define RFVIEWFACTORY_IOS5_SCREEN_SIZE 568
#define RFVIEWFACTORY_IOS5_COACHMARK_SUFFIX @"_5"

// shared settings
#define RFVIEWFACTORY_COACHMARK_ANIMATION_DURATION 0.2 // 200 ms

// stack size special values
#define STACK_SIZE_UNLIMITED 0
#define STACK_SIZE_DISABLED 1
