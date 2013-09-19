//
//  RFViewFactory.h
//  RFViewFactory
//
//  Created by Richard Fung on 1/31/13.
//  Copyright (c) 2013 rhfung. All rights reserved.
//

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

// call this method on load
-(void)registerView:(NSString*)sectionOrViewName;

// call this method to instantiate a view
-(UIViewController*)createViewController:(NSString*)sectionOrViewName;

+(BOOL)applyTransitionFromView:(UIView*)oldView toView:(UIView*)newView transition:(int)value completion:(void (^)(void))completion;

@end
