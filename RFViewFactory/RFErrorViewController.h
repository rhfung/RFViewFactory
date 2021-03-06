//
//  ErrorViewController.h
//  RFViewFactory
//
//  Created by Anthony Scherba on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// expecting a dictionary with:
// title
// description

@interface RFErrorViewController : UIViewController {
  IBOutlet UILabel *titleLabel;
  IBOutlet UILabel *descripLabel;
}

-(void)loadLatestErrorMessage;
-(IBAction) dismissError: (id) sender;
-(IBAction) reportError:(id)sender;

@end