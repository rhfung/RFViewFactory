//
//  UINavigationViewController+UINavigationViewController_PopByName.m
//  RFViewFactory
//
//  Created by Richard H Fung on 9/24/13.
//
//

#import "UINavigationController+PopByName.h"

@implementation UINavigationController (RFViewFactory_PopByName)

-(NSArray*)popToViewControllerNamed:(NSString*)viewControllerName animated:(BOOL)animated
{
  NSArray* arrVCs = [self findViewControllersNamed:viewControllerName];
  
  if (arrVCs.count == 0)
    return nil;
  else {
    // The root view controller is at index 0 in the array, the back view controller is at index n-2,
    // and the top controller is at index n-1, where n is the number of items in the array.
    // Thus, the closest matching object is the last one in the array that we built.
    return [self popToViewController:[arrVCs lastObject] animated:animated];
  }
}

-(UIViewController*)findFirstViewControllerNamed:(NSString*)viewControllerName {
  NSArray* arrResults = [self findViewControllersNamed:viewControllerName];
  if (arrResults.count > 0)
  {
    return arrResults[0];
  }
  return nil;
}

-(UIViewController*)findLastViewControllerNamed:(NSString*)viewControllerName {
  NSArray* arrResults = [self findViewControllersNamed:viewControllerName];
  if (arrResults.count > 0)
  {
    return arrResults.lastObject;
  }
  return nil;
}

-(NSArray*)findViewControllersNamed:(NSString*)viewControllerName {
  NSMutableArray* arrVCs = [[NSMutableArray alloc] init];

  // check all view controllers for vc's of the right type
  for (UIViewController* s in self.viewControllers)
  {
    if ([NSStringFromClass(s.class) isEqualToString:viewControllerName])
    {
      [arrVCs addObject:s];
    }
  }

  return arrVCs;
}

@end
