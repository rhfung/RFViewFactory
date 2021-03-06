//
//  RFIntent
//  RFViewFactory
//
//  Created by Richard Fung on 9/19/12.
//  Copyright (c) 2013 rhfung. All rights reserved.
//

#import "RFIntent.h"

@interface RFIntent() {
    NSString              *strSectionName;
    NSMutableDictionary   *dictextras;
}

@end

@implementation RFIntent


+(id) intentWithSectionName: (NSString*)name
{
  RFIntent* newIntent = [RFIntent alloc];
  return [newIntent initWithSectionName:name];
}

+(id) intentWithSectionName:(NSString*)name andSavedInstance:(NSMutableDictionary*)extras
{
  RFIntent* newIntent = [RFIntent alloc];
  return [newIntent initWithSectionName:name andSavedInstance:extras];
}

+(id) intentWithSectionName: (NSString*)name andAnimation:(UIViewAnimationOptions)animation
{
  RFIntent* newIntent = [RFIntent alloc];
  return [newIntent initWithSectionName:name  andAnimation:animation];
}


+(id) intentWithSectionName:(NSString*)sectionName andViewName:(NSString*)viewName
{
  RFIntent* newIntent = [RFIntent alloc];
  return [newIntent initWithSectionName:sectionName viewName:viewName];

}

+(id) intentWithSectionName:(NSString*)sectionName andViewName:(NSString*)viewName andAnimation:(UIViewAnimationOptions)animation
{
  RFIntent* newIntent = [[RFIntent alloc] initWithSectionName:sectionName viewName:viewName andAnimation:animation];
  return newIntent;
}

// intent for going to the last view, no animation
+(id) intentPreviousSection{
  return [RFIntent intentWithSectionName:SECTION_LAST];
}

// intent for going to the last view, any animation
+(id) intentPreviousSectionWithAnimation:(UIViewAnimationOptions)animation{
  return [RFIntent intentWithSectionName:SECTION_LAST andAnimation:animation];
}


-(id) initWithSectionName: (NSString*)name
{
  if (self = [super init])
  {
    strSectionName = name;
    dictextras = [NSMutableDictionary dictionaryWithCapacity:3];
  }
  return self;
}

-(id) initWithSectionName: (NSString*)name viewName:(NSString*)viewName 
{
  if (self = [super init])
  {
    strSectionName = name;
    
    dictextras = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictextras setObject:viewName forKey:@"viewName"];
    
  }
  return self;
}

-(id) initWithSectionName: (NSString*)name viewName:(NSString*)viewName andAnimation:(UIViewAnimationOptions)animation
{
  if (self = [super init])
  {
    strSectionName = name;
    
    dictextras = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictextras setObject:viewName forKey:@"viewName"];
    [self setAnimationStyle:animation];

  }
  return self;
}

-(id) initWithSectionName: (NSString*)name andAnimation:(UIViewAnimationOptions)animation
{
  if (self = [super init])
  {
    strSectionName = name;
    dictextras = [NSMutableDictionary dictionaryWithCapacity:3];
    [self setAnimationStyle:animation];
  }
  return self;
}

-(id) initWithSectionName: (NSString*)name andSavedInstance:(NSMutableDictionary*)extras
{
  if (self = [super init])
  {
    strSectionName = name;
    dictextras = extras;
  }
  
  return self;
}

-(NSString*) sectionName
{
  return strSectionName;
}

-(NSMutableDictionary*) extras
{
  return dictextras;
}

// returns the viewName in the extras, if available, or nil otherwise
-(NSString*) viewName
{
  if (dictextras)
  {
    return [dictextras objectForKey:@"viewName"];
  }
  else
  {
    return nil;
  }
}

-(UIViewAnimationOptions)animationStyle{
  if (dictextras){
    return [[dictextras objectForKey:@"animationStyle"] intValue];
  }
  else {
    return UIViewAnimationOptionTransitionNone;
  }
}

-(void)setAnimationStyle:(UIViewAnimationOptions)animationStyle{
  if (!dictextras){
    dictextras = [NSMutableDictionary dictionaryWithCapacity:10];
  }
  
  [dictextras setObject:[NSNumber numberWithInt:animationStyle] forKey:@"animationStyle"];
}

-(NSString *)description{
  return [NSString stringWithFormat:@"RFIntent section=%@, view=%@, dictionary=%@", self.sectionName, self.viewName, self.extras];
}

@end

@implementation RFIntent (PrivateMethods)

-(void)setSectionName:(NSString*)newName{
    strSectionName = newName;
}

@end
