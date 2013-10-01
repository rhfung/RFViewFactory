//
//  RFViewFactory.m
//  RFViewFactory
//
//  Created by Richard Fung on 1/31/13.
//  Copyright (c) 2013 rhfung. All rights reserved.
//

#import "RFViewFactory.h"
#import "RFMainViewController.h"
#import <QuartzCore/QuartzCore.h>


// ref. http://stackoverflow.com/questions/923706/checking-if-a-nib-or-xib-file-exists
#define AssertFileExists(path) NSAssert([[NSFileManager defaultManager] fileExistsAtPath:path], @"Cannot find the file: %@", path)
#define AssertNibExists(file_name_string) AssertFileExists([[NSBundle mainBundle] pathForResource:file_name_string ofType:@"nib"])

@interface RFViewFactoryEntry : NSObject {
}
@property NSString* nibName;
@property NSString* className;

@end

@implementation RFViewFactoryEntry
@synthesize nibName;
@synthesize className;

@end

@implementation RFViewFactory

@synthesize debugMode = _debugMode;

+(RFViewFactory*)sharedFactory
{
    static dispatch_once_t _singletonPredicate;
    static RFViewFactory* _sharedFactory = nil;
    
	dispatch_once(&_singletonPredicate, ^{
        _sharedFactory = [[super allocWithZone:nil] init];
    });
    
    return _sharedFactory;
}

+ (id) allocWithZone:(NSZone *)zone {
    return [self sharedFactory];
}

+ (id) alloc {
    return [self sharedFactory];
}

-(id)init{
  if (self = [super init]){
    viewControllers = [NSMutableDictionary dictionaryWithCapacity:20];
    [self registerView:VIEW_BUILTIN_MAIN andNibName:VIEW_BUILTIN_MAIN_NIB];
    [self registerView:VIEW_BUILTIN_ERROR andNibName:VIEW_BUILTIN_ERROR_NIB];
  }
  
  return self;
}

-(UIViewController*)createViewController:(NSString*)sectionOrViewName {
  return [self createViewController:sectionOrViewName withDictionary:nil];
}

-(UIViewController*)createViewController:(NSString*)sectionOrViewName withDictionary:(NSDictionary *)creationDictionary {
  RFViewFactoryEntry* entry = [viewControllers objectForKey:sectionOrViewName];
  Class class = NSClassFromString(sectionOrViewName);
  NSAssert(class != nil, @"Class %@ is not found in your project", sectionOrViewName);
  
  AssertNibExists(entry.nibName);
  UIViewController* vc = [[class alloc] initWithNibName:entry.nibName bundle:nil] ;
  
  if ([vc isKindOfClass:[RFViewController class]]){
    RFViewController* vc2 = (RFViewController*) vc;
    [vc2 onCreate:creationDictionary];
  }
  
#ifdef DEBUG
  NSLog(@"Created a view controller %@", vc);
#endif
  return vc;
}

-(void)registerView:(NSString*)sectionOrViewName{
  RFViewFactoryEntry* entry = [[RFViewFactoryEntry alloc] init];
  entry.nibName = sectionOrViewName;
  entry.className = sectionOrViewName;
  
  [viewControllers setObject:entry  forKey:sectionOrViewName];
    
  if (_debugMode){
    [self createViewController:sectionOrViewName];
  }
}

-(void)registerView:(NSString*)sectionOrViewName andNibName:(NSString*)nibName {
  RFViewFactoryEntry* entry = [[RFViewFactoryEntry alloc] init];
  entry.nibName = nibName;
  entry.className = sectionOrViewName;
  
  [viewControllers setObject:entry  forKey:sectionOrViewName];

  if (_debugMode){
    [self createViewController:sectionOrViewName];
  }
}

// this method offers custom animations that are not provided by UIView, mainly the
// slide left and right animations (no idea why Apple separated these animations)
+(BOOL)applyTransitionFromView:(UIView*)oldView toView:(UIView*)newView transition:(int)value completion:(void (^)(void))completion  { // not the best place for this code but it'll work for now
  NSString *transition = nil;
  NSString *subTransition = nil;
	if (value == ANIMATION_PUSH ) {
    transition = kCATransitionPush;
		subTransition = kCATransitionFromRight;
	} else if (value == ANIMATION_POP ) {
    transition = kCATransitionPush;
		subTransition = kCATransitionFromLeft;
  } else {
    return NO;
  }

  CGPoint finalPosition = oldView.center;
  CGPoint leftPosition = CGPointMake(-oldView.frame.size.width + finalPosition.x, finalPosition.y);
  CGPoint rightPosition = CGPointMake(finalPosition.x + oldView.frame.size.width, finalPosition.y);
  
  if (value == ANIMATION_PUSH){
    newView.center = rightPosition;
    
    [UIView animateWithDuration:0.5 animations:^{
      oldView.center = leftPosition;
      newView.center = finalPosition;
    } completion:^(BOOL finished) {
      completion();
      oldView.center = finalPosition;
    }];
  }else{
    newView.center = leftPosition;
    
    [UIView animateWithDuration:0.5 animations:^{
      oldView.center = rightPosition;
      newView.center = finalPosition;
    } completion:^(BOOL finished) {
      completion();
      oldView.center = finalPosition;
    }];
  }
  
  return YES;
}

// call this method on load to register everything to the sharedFactory
+(void)registerView:(NSString*)sectionOrViewName{
  return [[self sharedFactory] registerView:sectionOrViewName];
}

// call this method to instantiate a view (rarely called directly) to create view controllers
+(UIViewController*)createViewController:(NSString*)sectionOrViewName {
  return [RFViewFactory createViewController:sectionOrViewName withDictionary:nil];
}

// call this method to instantiate a view (rarely called directly) to create view controllers
+(UIViewController*)createViewController:(NSString*)sectionOrViewName withDictionary:(NSDictionary*)creationDictionary
{
  return [[self sharedFactory] createViewController:sectionOrViewName withDictionary:creationDictionary];
}



@end
