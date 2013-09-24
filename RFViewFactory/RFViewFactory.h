//
//  RFViewFactory.h
//  RFViewFactory
//
//  Created by Richard Fung on 1/31/13.
//  Copyright (c) 2013 rhfung. All rights reserved.
//

// RFViewFactory is a singleton object that registers view controller names and creates them when called.
// RFViewFactory does not provide any caching or other features.
//
// When debugMode is set to TRUE, it will verify that the view controllers exist in .XIB files on registration.s

#import "RFConstants.h"
#import "RFSectionViewController.h"
#import "RFViewController.h"
#import "RFViewFactory.h"
#import "RFViewModel.h"
#import "RFIntent.h"

#import <Foundation/Foundation.h>

@interface RFViewFactory : NSObject{
    NSMutableDictionary* viewControllers;
}

// singleton object
+(RFViewFactory*)sharedFactory;

// call this method on load to register everything, same as calling the instance method on sharedFactory
+(void)registerView:(NSString*)sectionOrViewName;

// call this method to instantiate a view (rarely called directly) to create view controllers, same as calling the instance method on sharedFactory
+(UIViewController*)createViewController:(NSString*)sectionOrViewName;

// call this method to manually run the animation between views
+(BOOL)applyTransitionFromView:(UIView*)oldView toView:(UIView*)newView transition:(int)value completion:(void (^)(void))completion;




// call this method on load
-(void)registerView:(NSString*)sectionOrViewName;

// set the debug mode. will test if all views/sections are added correctly in the app on startup
@property BOOL debugMode;

// call this method to instantiate a view (rarely called directly)
-(UIViewController*)createViewController:(NSString*)sectionOrViewName;


@end
