//
//  RFViewController.h
//  RFViewFactory
//
//  Created by Richard Fung on 9/19/12.
//  Copyright (c) 2013 rhfung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFIntent.h"

@interface RFViewController : UIViewController

// Refer to http://developer.android.com/reference/android/app/Activity.html
// for the lifecycle of a ViewController. (Yeah, I know, I'm copying Android intents.)

// This tag is used for internal debugging purposes only. Do not use.
@property () BOOL debugTag;

// When overriding these methods, the superclass's onResume and onPause must be called.

// Called when the activity is first created. This is where you should do all of your non-GUI setup. For GUI setup, override viewDidLoad.
-(void)onCreate:(NSDictionary*)creationDictionary;

// Called when the activity will start interacting with the user. At this point your activity is at the top of the activity stack, with user input going to it. Always followed by onPause().
-(void)onResume:(RFIntent*)intent;

// Called when the system is about to start resuming a previous activity. This is typically used to commit unsaved changes to persistent data, stop animations and other things that may be consuming CPU, etc. Implementations of this method must be very quick because the next activity will not be resumed until this method returns. Followed by either onResume() if the activity returns back to the front, or onStop() if it becomes invisible to the user.
-(void)onPause:(RFIntent*)intent;

@end
