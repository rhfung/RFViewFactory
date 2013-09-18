//
//  RFSectionViewController.m
//  RFViewFactory
//
//  Created by Richard Fung on 2/7/13.
//  Copyright (c) 2013 rhfung. All rights reserved.
//

#import "RFSectionViewController.h"
#import "RFViewFactory.h"

@interface RFSectionViewController ()

@end

@implementation RFSectionViewController

@synthesize innerView;
@synthesize currentViewVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
  
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)onResume:(RFIntent *)intent{
  [super onResume:intent];
  
  if (currentViewVC) {
    [currentViewVC onResume:intent];
  }
  
  
}

-(void)onPause:(RFIntent *)intent{
  if (currentViewVC){
    [currentViewVC onPause:intent];
  }
  [super onPause:intent];

}

@end
