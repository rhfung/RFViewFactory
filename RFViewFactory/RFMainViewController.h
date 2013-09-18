//
//  RFMainViewController.h
//  RFViewFactory
//
//  Created by Richard Fung on 1/22/13.
//  Copyright (c) 2013 rhfung. All rights reserved.
//
// TODO: disable auto power off

#import <UIKit/UIKit.h>
#import "RFSectionViewController.h"
#import "RFErrorViewController.h"
#import "RFConstants.h"

@interface RFMainViewController : RFViewController {
  
  NSMutableDictionary *dictCacheView;
  RFErrorViewController* errorVC;
  RFSectionViewController* currentSectionVC;
  RFIntent* activeIntent;
  UIButton* screenOverlayButton;
  NSArray* screenOverlaySlideshow;
}


@end
