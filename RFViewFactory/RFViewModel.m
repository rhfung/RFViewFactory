//
//  RFAppModel.m
//  RFViewFactory
//
//  Created by Richard Fung on 3/15/13.
//  Copyright (c) 2013 rhfung. All rights reserved.
//

#import "RFViewModel.h"

@implementation RFViewModel

@synthesize errorDict;
@synthesize currentSection;
@synthesize historyStack;
@synthesize coachmark;
@synthesize stackSize;

+(RFViewModel*)sharedModel
{
    static dispatch_once_t _singletonPredicate;
    static RFViewModel* _sharedModel = nil;

    dispatch_once(&_singletonPredicate, ^{
        _sharedModel = [[super allocWithZone:nil] init];
    });
	return _sharedModel;
}

+ (id) allocWithZone:(NSZone *)zone {
    return [self sharedModel];
}

+ (id) alloc {
    return [self sharedModel];
}


-(id)init{
  if (self = [super init]){
    stackSize = 0;
    [self clearHistoryStack];
  }
  
  return self;
}

-(void)clearHistoryStack{
    historyStack = [NSMutableArray arrayWithCapacity:stackSize];
}

-(void)clearViewCache{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"RFMainViewController_flushViewCache" object:self];
}

-(void) setErrorTitle:(NSString*) title andDescription:(NSString*) description
{
  if (title == nil)
    title = @"";
  
  if (description == nil)
    description = @"";
  
  [self setErrorDict: [NSDictionary dictionaryWithObjects:@[title, description] forKeys:@[@"title", @"description"]]];
}

@end

