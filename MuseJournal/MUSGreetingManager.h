//  MUSGreetingManager.h
//  MuseApp

#import <Foundation/Foundation.h>
#import "MUSTimeFetcher.h"
#import "MUSBlurOverlayViewController.h"

@interface MUSGreetingManager : NSObject


-(instancetype)initWithTimeOfDay:(TimeOfDay)time firstName:(NSString *)name;
+(BOOL)presentFirstTimeEntry;
+(MUSBlurOverlayViewController*) returnEntryWalkthrough;

@property (strong, nonatomic) NSString* userGreeting;

@end
