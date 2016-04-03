//
//  MUSAutoPlayManager.m
//  Muse


#import "MUSAutoPlayManager.h"

@implementation MUSAutoPlayManager

+(BOOL)returnAutoPlayStatus {
  BOOL autoplayStatus = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoplay"];
  if (autoplayStatus)
    return YES;
  else
    return NO;
}

+(BOOL)returnAutoPauseStatus {
  BOOL autoPauseStatus = [[NSUserDefaults standardUserDefaults] boolForKey:@"autopause"];
  if (autoPauseStatus)
    return YES;
  else
    return NO;
}

@end
