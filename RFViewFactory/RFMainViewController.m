//
//  RFMainViewController.m
//  RFViewFactory
//
//  Created by Richard Fung on 1/22/13.
//  Copyright (c) 2013 rhfung. All rights reserved.
//

#import "RFViewController.h"
#import "RFViewModel.h"
#import "RFErrorViewController.h"
#import "RFMainViewController.h"
#import "RFSectionViewController.h"
#import "RFViewFactory.h"



// this function taken from http://stackoverflow.com/questions/10330679/how-to-dispatch-on-main-queue-synchronously-without-a-deadlock
void rfvf_runOnMainQueueWithoutDeadlocking(void (^block)(void))
{
  if ([NSThread isMainThread])
  {
    block();
  }
  else
  {
    dispatch_sync(dispatch_get_main_queue(), block);
  }
}

@interface RFIntent (PrivateMethods)

-(void)setSectionName:(NSString*)newSectionName;

@end


@implementation RFMainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      // register to listeners on model changes
      [[RFViewModel sharedModel] addObserver:self forKeyPath:@"currentSection" options: NSKeyValueObservingOptionNew context: nil];
      [[RFViewModel sharedModel] addObserver:self forKeyPath:@"errorDict" options: NSKeyValueObservingOptionNew context: nil];
      [[RFViewModel sharedModel] addObserver:self forKeyPath:@"coachmark" options: NSKeyValueObservingOptionNew context: nil];
      [[RFViewModel sharedModel] addObserver:self forKeyPath:@"coachmarks" options: NSKeyValueObservingOptionNew context: nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flushViewCache:) name:@"RFMainViewController_flushViewCache" object:[RFViewModel sharedModel]]; // last parameter filters the response
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{

  
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
  
  dictCacheView = [NSMutableDictionary dictionaryWithCapacity:10];
}

// Selector that specifies the message the receiver sends notificationObserver to notify it of the notification posting. The method specified by notificationSelector must have one and only one argument (an instance of NSNotification).
-(void)flushViewCache:(id)sender{
  dictCacheView = [NSMutableDictionary dictionaryWithCapacity:10];  
}


// callback from the observer listener pattern
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"currentSection"]) {
      rfvf_runOnMainQueueWithoutDeadlocking(^{
        [self goToSection:[RFViewModel sharedModel].currentSection];
      });
    
  } 
  else if ([keyPath isEqualToString:@"errorDict"]) {
  //NSDictionary *errorDict = [change objectForKey:NSKeyValueChangeNewKey];
  //[errorDict objectForKey: @"name"];
      rfvf_runOnMainQueueWithoutDeadlocking(^{
        if (!errorVC)
          errorVC = (RFErrorViewController*) [RFViewFactory createViewController:VIEW_BUILTIN_ERROR];
        
        // remove from the previous
        [errorVC.view removeFromSuperview];
        [errorVC removeFromParentViewController];
        
        // set up
        [errorVC loadLatestErrorMessage];
        
        // add to the current
        [errorVC.view setFrame:[self.view bounds]];
        [self.view addSubview: errorVC.view];
        
        [currentSectionVC.currentViewVC.view resignFirstResponder];
        [currentSectionVC.view resignFirstResponder];
        
        
        [errorVC becomeFirstResponder]; // make the error dialog the first responder
      });
  }else if ([keyPath isEqualToString:@"coachmark"]){
    rfvf_runOnMainQueueWithoutDeadlocking(^{
      [self showCoachmarks:@[[RFViewModel sharedModel].coachmark]];
    });
  }
  else if ([keyPath isEqualToString:@"coachmarks"]){
    rfvf_runOnMainQueueWithoutDeadlocking(^{
      [self showCoachmarks:[RFViewModel sharedModel].coachmarks];
    });
  }else{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
  
}

-(void)showCoachmarks:(NSArray*)overlays{
  coachmarkSlides = overlays;
  
  if (!overlays || overlays.count == 0){
    if (coachmarkButton){
      // fade out the overlay in 200 ms
      coachmarkButton.alpha = 1.0;
      [UIView animateWithDuration:RFVIEWFACTORY_COACHMARK_ANIMATION_DURATION animations:^{
        coachmarkButton.alpha = 0.0;
      } completion:^(BOOL finished) {
        [coachmarkButton resignFirstResponder];
        [coachmarkButton removeFromSuperview];
        coachmarkButton = nil;
      }];
    }
    return;
  }
  
  // load the overlay 
  if (!coachmarkButton){
    // set up the geometry of the new screen overlay
    CGRect rect = [self.view bounds];
    coachmarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    coachmarkButton.frame = rect;
    coachmarkButton.contentMode = UIViewContentModeScaleToFill;
  }
  
  // this code will load 2 images on iPhone 5, one for the small screen and another image for the large screen
  
  // automatically remove the .png/.PNG extension
  NSString* overlayName = [overlays objectAtIndex:0];
  if ([[overlayName pathExtension] compare:@"png" options:NSCaseInsensitiveSearch] == NSOrderedSame){
    overlayName = [overlayName stringByDeletingPathExtension];
  }
  // load the image
  UIImage* imgOverlay = [UIImage imageNamed:overlayName];
  
  // check screen dimensions
  CGRect appFrame = [[UIScreen mainScreen] bounds];
  if (appFrame.size.height >= RFVIEWFACTORY_IOS5_SCREEN_SIZE) // add in the _5 to the filename, shouldn't append .png
  {
    // test for an iPhone 5 overlay. If available, use that overlay instead.
    overlayName = [NSString stringWithFormat:@"%@%@", overlayName, RFVIEWFACTORY_IOS5_COACHMARK_SUFFIX];
    if ([UIImage imageNamed:overlayName]){
      imgOverlay = [UIImage imageNamed:overlayName];
    }
  }
  
  // show the new overlay
  if (imgOverlay){
    [coachmarkButton setImage:imgOverlay forState:UIControlStateNormal];
    [coachmarkButton addTarget:self action:@selector(coachmarkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    if (![self.view.subviews containsObject:coachmarkButton]){
      coachmarkButton.alpha = 0.0;
      [self.view addSubview:coachmarkButton];
      [UIView animateWithDuration:RFVIEWFACTORY_COACHMARK_ANIMATION_DURATION animations:^{
        coachmarkButton.alpha = 1.0;
      }];
    }
    [self.view bringSubviewToFront:coachmarkButton];
    [coachmarkButton becomeFirstResponder];
  }else{
#ifdef DEBUG
    NSAssert(false, @"Coachmark image file not found: %@", [RFViewModel sharedModel].coachmark);
#endif
  }

}

- (void)coachmarkButtonPressed:(id)sender{
  NSMutableArray* newArray = [NSMutableArray arrayWithArray:coachmarkSlides];
  if (newArray.count > 0)
    [newArray removeObjectAtIndex:0];
  coachmarkSlides = newArray;
  [self showCoachmarks:newArray];
}

-(RFViewController*) loadOrCreateViewController:(NSString*)sectionOrViewName{
  // create global view cache if it doesn't already exist
  if (!dictCacheView){
    dictCacheView = [NSMutableDictionary dictionaryWithCapacity:10];
  }
  
  // test for existence
  RFViewController* vc = [dictCacheView objectForKey:sectionOrViewName];
  if (vc == nil){
    // create the view controller
    vc = (RFViewController*) [RFViewFactory createViewController:sectionOrViewName];
    NSAssert(vc != nil, @"VC should exist");
    [dictCacheView setObject:vc forKey:sectionOrViewName];
  }
  
  return vc;
}

-(RFViewController*) forceLoadViewController:(NSString*)sectionOrViewName{
  // create global view cache if it doesn't already exist
  if (!dictCacheView){
    dictCacheView = [NSMutableDictionary dictionaryWithCapacity:10];
  }

  // create the view controller
  RFViewController* vc = (RFViewController*) [RFViewFactory createViewController:sectionOrViewName];
  NSAssert(vc != nil, @"VC should exist");
  [dictCacheView setObject:vc forKey:sectionOrViewName];
  return vc;
}

-(void)pushToHistoryStack:(RFIntent*)intent{
  if ([RFViewModel sharedModel].stackSize == STACK_SIZE_DISABLED){
    // don't save anything to the stack
    return;
  }else if ([RFViewModel sharedModel].stackSize != STACK_SIZE_UNLIMITED){
    // bound the size 
    NSAssert([RFViewModel sharedModel].stackSize > 0, @"stack size must be positive");
    
    if ([RFViewModel sharedModel].historyStack.count >= [RFViewModel sharedModel].stackSize  && [RFViewModel sharedModel].historyStack > 0){
      [[RFViewModel sharedModel].historyStack removeObjectAtIndex:0]; // remove the first object to keep the stack size bounded
    }
  }
  
  // add the new object on the stack
  [[[RFViewModel sharedModel] historyStack] addObject:intent];
}

-(RFIntent*)popHistoryStack{
  NSAssert([RFViewModel sharedModel].historyStack.count > 0, @"something should be on the stack");
  
  if ([RFViewModel sharedModel].historyStack.count > 0){
    [[RFViewModel sharedModel].historyStack removeLastObject]; // this is the shown view, we don't want to stay on this view so discard it
    RFIntent* retIntent = [[RFViewModel sharedModel].historyStack lastObject]; // this is the previous view, we keep a ref to this
    return retIntent;
  }
  
  return nil; // nothing on the history stack
}

-(RFIntent*)loadIntentAndHandleHistoryStack:(RFIntent*)intent{
  if ([[intent sectionName] isEqualToString:SECTION_LAST]){
    // but don't retain the SECTION or VIEW from the "previous" intent
    NSMutableDictionary* savedState = [NSMutableDictionary dictionaryWithDictionary:[intent savedInstanceState]];
    [savedState removeObjectForKey:@"viewName"]; // unusual design decision, sectionName is not saved in the savedState object
    
    // when  copying state values from the given intent, e.g., animation transition, to the old bundle
    RFIntent* previousIntent = [self popHistoryStack];
#ifdef DEBUG
    if (previousIntent == nil){
      if ([RFViewModel sharedModel].stackSize == STACK_SIZE_DISABLED){
        NSLog(@"Cannot pop an empty stack because the stack size is set to STACK_SIZE_DISABLED. You should assign [RFViewModel sharedModel].stackSize on startup.");
      }else if ([RFViewModel sharedModel].stackSize == STACK_SIZE_UNLIMITED){
        NSLog(@"Navigating back in the history stack too many times. You can check for an empty history stack by inspecting [RFViewModel sharedModel].historyStack.count > 1");
      }else if ([RFViewModel sharedModel].stackSize > 0){
        NSLog(@"Cannot pop an empty stack. Perhaps your stack size = %d is too small? You should check [RFViewModel sharedModel].stackSize", [RFViewModel sharedModel].stackSize);
      }else{
        NSLog(@"Unexpected stack size. Please ticket this problem to the developers.");
      }
    }
#endif
    NSAssert(previousIntent != nil, @"Cannot pop an empty history stack.");

    if (previousIntent == nil){
      // default behaviour is to stop changing intents, the current intent is set to an improper state
      return nil;
    }
    
    // replace the intent on the history stack
    [[previousIntent savedInstanceState] setValuesForKeysWithDictionary:savedState];
      
    // modify the object that was passed in with the appropriate information
    [[intent savedInstanceState] setValuesForKeysWithDictionary:previousIntent.savedInstanceState];
    intent.sectionName = previousIntent.sectionName;
      
    return previousIntent;
  }else{
    // build the history stack
    [self pushToHistoryStack:intent];
  }

  return intent;
}

-(void)goToSection:(RFIntent*)intent{
  // handle the history stack
  intent = [self loadIntentAndHandleHistoryStack:intent];
  if (!intent)
    return;
  
  // load the appropriate views from cache

  RFSectionViewController* sectionVC =  (RFSectionViewController*)  [self loadOrCreateViewController:[intent sectionName]];
  NSAssert([sectionVC isKindOfClass:[RFSectionViewController class]], @"sections should be subclasses of RFSectionViewController");
  
  RFViewController* vc = nil;
  if ([intent viewName]){
    vc = (RFViewController*) [self loadOrCreateViewController:[intent viewName]];
    NSAssert([vc isKindOfClass:[RFViewController class]], @"views should be subclasses of RFViewController");
  
    // edge case: everything we are transitioning to is the same as the previous, need to create a new view
    if (sectionVC == currentSectionVC && vc == currentSectionVC.currentViewVC){
//      sectionVC = (RFSectionViewController*) [self forceLoadViewController:[intent sectionName]];
      vc = (RFViewController*) [self forceLoadViewController:[intent viewName]];
    }
  }else{
    // edge case: transitioning from itself to itself, need to create a new view
    if (sectionVC == currentSectionVC){
      sectionVC = (RFSectionViewController*) [self forceLoadViewController:[intent sectionName]];
    }
  }

  // save changes to the previous intent
  // automatically propagates onPause to its child view
  if (currentSectionVC){
    // reset debug flags
    currentSectionVC.debugTag = NO;
    if (currentSectionVC.currentViewVC)
      currentSectionVC.currentViewVC.debugTag = NO;
    
//    NSLog(@"Pause %@", activeIntent);
    [currentSectionVC onPause:activeIntent];
    
#ifdef DEBUG
    if (!currentSectionVC.debugTag)
      NSLog(@"Subclass %@ of RFSectionViewController did not have its [super onPause:intent] called", currentSectionVC);
    if (currentSectionVC.currentViewVC && !currentSectionVC.currentViewVC.debugTag)
      NSLog(@"Subclass %@ of RFViewController did not have its [super onPause:intent] called", currentSectionVC.currentViewVC);
#endif
  }

  // switch the views
  [self loadNewSection:sectionVC andView:vc withIntent:intent];
  
  // reset debug flags
  currentSectionVC.debugTag = NO;
  if (currentSectionVC.currentViewVC)
    currentSectionVC.currentViewVC.debugTag = NO;

  // resume on the section will also resume the view
  activeIntent = intent;
  [sectionVC onResume:intent];
//  NSLog(@"Resume %@", intent);
  
#ifdef DEBUG
  if (!currentSectionVC.debugTag)
    NSLog(@"Subclass %@ of RFSectionViewController did not have its [super onResume:intent] called", currentSectionVC);
  if (currentSectionVC.currentViewVC && !currentSectionVC.currentViewVC.debugTag)
    NSLog(@"Subclass %@ of RFViewController did not have its [super onResume:intent] called", currentSectionVC.currentViewVC);
#endif
}

-(void)loadNewSection:(RFSectionViewController*)sectionVC andView:(RFViewController*)viewVC withIntent:(RFIntent*)intent{
  int transitionStyle = [intent animationStyle];
  
  if (currentSectionVC != sectionVC){ // replace the section VC
//        NSLog(@"Different section");

    // configure the position and layout of the section frame to fit the main frame
    sectionVC.view.hidden = NO;
    CGRect rect = sectionVC.view.frame;
    rect.origin = CGPointMake(0, 0);
    rect.size = self.view.frame.size;
    [sectionVC.view setFrame:rect];

    // three steps to show the VC
    [self addChildViewController:sectionVC];
    [self.view addSubview:sectionVC.view];
    [sectionVC didMoveToParentViewController:self];

    RFSectionViewController* oldSectionVC = currentSectionVC;
    [oldSectionVC.currentViewVC resignFirstResponder];
    [oldSectionVC resignFirstResponder];
    
    // opResult becomes true when an animation is applied, then we don't need to call our other animation code
//    BOOL opResult = [RFViewFactory applyTransitionToView:self.view transition:transitionStyle];
    BOOL opResult = [RFViewFactory applyTransitionFromView:currentSectionVC.view toView:sectionVC.view transition:transitionStyle completion:^{
      if (oldSectionVC != currentSectionVC){
        [oldSectionVC willMoveToParentViewController:nil];
        [oldSectionVC.view removeFromSuperview];
        [oldSectionVC removeFromParentViewController];
      }
    }];
    
    // TODO: figure out why this code path gets called (note the transition speeds are different)
    if (!opResult && currentSectionVC.view != sectionVC.view){ // if animation was not applied
      [UIView transitionFromView:currentSectionVC.view toView:sectionVC.view duration:0.25 options:(transitionStyle | UIViewAnimationOptionShowHideTransitionViews) completion:^(BOOL finished) {
        if (oldSectionVC != currentSectionVC){
          [oldSectionVC willMoveToParentViewController:nil];
          [oldSectionVC.view removeFromSuperview];
          [oldSectionVC removeFromParentViewController];
        }
      }];
    }
    
    NSAssert(self.view.subviews.count < 5, @"clearing the view stack");
    
    // reset the animation style, don't animate the view if the section has already been animated
    transitionStyle = UIViewAnimationOptionTransitionNone;
  }else{
//    NSLog(@"Same section");
  }
  
  // load the view inside the section
  RFViewController* oldViewVC = sectionVC.currentViewVC;
  
  // if the view controller is the same as before, don't load it again
  if (oldViewVC != viewVC){
//        NSLog(@"different view");
    [oldViewVC resignFirstResponder];
  
    if (viewVC){
//          NSLog(@"attach view to section");

      // size the view
      viewVC.view.hidden = NO;
      CGRect rect = viewVC.view.frame;
      rect.origin = CGPointMake(0, 0);
      rect.size = sectionVC.innerView.bounds.size;
      [viewVC.view setFrame:rect];

      // add the view to the section
      [sectionVC addChildViewController:viewVC];
      [sectionVC.innerView addSubview:viewVC.view];
      [viewVC didMoveToParentViewController:sectionVC];

      // TODO: why there's two code paths for animation here?
      BOOL opResult = [RFViewFactory applyTransitionFromView:oldViewVC.view toView:viewVC.view transition:transitionStyle completion:^{
        if (sectionVC.currentViewVC != oldViewVC){
          [oldViewVC willMoveToParentViewController:nil];
          [oldViewVC.view removeFromSuperview];
          [oldViewVC removeFromParentViewController];
        }
      }];

      if (oldViewVC.view != viewVC.view && !opResult){
        
        [UIView transitionFromView:oldViewVC.view toView:viewVC.view duration:0.250 options:(transitionStyle |UIViewAnimationOptionShowHideTransitionViews) completion:^(BOOL finished) {
          if (sectionVC.currentViewVC != oldViewVC){
            [oldViewVC willMoveToParentViewController:nil];
            [oldViewVC.view removeFromSuperview];
            [oldViewVC removeFromParentViewController];
          }
        }];
      }
    } else { // no view controller
//      NSLog(@"remove view from section");
      [oldViewVC willMoveToParentViewController:nil];
      [oldViewVC.view removeFromSuperview];
      [oldViewVC removeFromParentViewController];
    }
  
    NSAssert(sectionVC.innerView.subviews.count < 5, @"clearing the view stack");
  }else{
//    NSLog(@"same view");
//    NSAssert([[sectionVC.innerView subviews] containsObject:oldViewVC.view], @"view should already be shown");
  }
    
  currentSectionVC = sectionVC;
  currentSectionVC.currentViewVC = viewVC;
}

-(void)clearView:(UIViewController*) view {
	for (UIViewController *vc in view.childViewControllers) {
    [vc.view resignFirstResponder]; // close the keyboard
		[vc.view removeFromSuperview];
	}
	
  [view.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
  
}

@end
