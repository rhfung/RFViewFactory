//
//  RFViewController.m
//  RFViewFactory
//
//  Created by Richard Fung on 9/19/12.
//  Copyright (c) 2013 rhfung. All rights reserved.
//

#import "RFViewController.h"

@implementation RFViewController

@synthesize debugTag;

-(void)onCreate{
  
}

-(void)onResume:(RFIntent*)intent
{
  self.debugTag = YES;
}

-(void)onPause:(RFIntent*)intent
{
  self.debugTag = YES;
}

@end
