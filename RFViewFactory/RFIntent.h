//
//  RFIntent.h
//  RFViewFactory
//
//  Created by Richard Fung on 9/19/12.
//  Copyright (c) 2013 rhfung. All rights reserved.
//
// AppModelIntent is wired through AppModel and handled by RFMainViewController.

#import <Foundation/Foundation.h>
#import "RFConstants.h"

// see the architecture design from Android:
// http://developer.android.com/reference/android/app/Activity.html
//
// ViewControllers are "activities" that receive bundles
@interface RFIntent : NSObject

// Steps to use this object:
//
// 1.  RFIntent* intent = [RFIntent intentWithSectionName:SECTION_?? viewName:VIEW_??]
//     Create the intent object
//
// 2. [[intent getSavedInstance] setObject:?? forKey:@"viewSpecificKey"]
//     Assign any/all view-specific instructions. Read header files for definition.
//
// 3. [[RFViewModel] setCurrentSection:intent];
//     Load the section.
//

// rarely any SECTION_ has no VIEW_
+(id) intentWithSectionName: (NSString*)name;

// only used by the undo operation
+(id) intentWithSectionName:(NSString*)name andSavedInstance:(NSMutableDictionary*)extras;

// preferable animations are ANIMATION_NOTHING, ANIMATION_PUSH, ANIMATION_POP, UIViewAnimationOptionTransitionCrossDissolve
+(id) intentWithSectionName: (NSString*)name andAnimation:(UIViewAnimationOptions)animation;

// most commonly called SECTION_ and VIEW_ pairing
+(id) intentWithSectionName:(NSString*)sectionName andViewName:(NSString*)viewName;

// preferable animations are ANIMATION_NOTHING, ANIMATION_PUSH, ANIMATION_POP, UIViewAnimationOptionTransitionCrossDissolve
+(id) intentWithSectionName:(NSString*)sectionName andViewName:(NSString*)viewName andAnimation:(UIViewAnimationOptions)animation;

// intent for going to the last view, no animation
+(id) intentPreviousSection;

// intent for going to the last view, any animation
+(id) intentPreviousSectionWithAnimation:(UIViewAnimationOptions)animation;

// getters
@property (nonatomic, retain, readonly) NSString* sectionName;
@property (nonatomic, retain, readonly) NSString* viewName;
@property (nonatomic, retain, readonly) NSMutableDictionary* extras;
@property () UIViewAnimationOptions animationStyle;


@end
