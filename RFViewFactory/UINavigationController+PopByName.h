//
//  UINavigationViewController+UINavigationViewController_PopByName.h
//  RFViewFactory
//
//  Created by Richard H Fung on 9/24/13.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (RFViewFactory_PopByName)

/// Pop several view controllers on the stack.
-(NSArray*)popToViewControllerNamed:(NSString*)viewControllerName animated:(BOOL)animated;

/// Find the earliest view controller pushed on the stack with a given name.
-(UIViewController*)findFirstViewControllerNamed:(NSString*)viewControllerName;

/// Find the most recently seen view controller with a name.
-(UIViewController*)findLastViewControllerNamed:(NSString*)viewControllerName;

/// Find all view controllers that match a given class.
-(NSArray*)findViewControllersNamed:(NSString*)viewControllerName;

@end

