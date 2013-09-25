//
//  UINavigationViewController+UINavigationViewController_PopByName.h
//  RFViewFactory
//
//  Created by Richard H Fung on 9/24/13.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (RFViewFactory_PopByName)

-(NSArray*)popToViewControllerNamed:(NSString*)viewControllerName animated:(BOOL)animated;

@end

