//
//  MUSNotificationDelegate.m
//  
//


#import "MUSNotificationDelegate.h"
#import <CWStatusBarNotification/CWStatusBarNotification.h>

@interface MUSNotificationDelegate()<MUSNotificationDelegate>

@end

@implementation MUSNotificationDelegate

-(void)displayNotificationForSongName:(NSString *)title{
    NSLog(@"do you get called?");
    CWStatusBarNotification *pinSuccessNotification = [CWStatusBarNotification new];
    pinSuccessNotification.notificationStyle = CWNotificationStyleStatusBarNotification;
    pinSuccessNotification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
    pinSuccessNotification.notificationAnimationOutStyle = CWNotificationAnimationStyleBottom;
    NSString *successMessage = [NSString stringWithFormat:@"Successfully Pinned '%@'", title];
    pinSuccessNotification.notificationLabelBackgroundColor = [UIColor colorWithRed:0.21 green:0.72 blue:0.00 alpha:1.0];
    pinSuccessNotification.notificationLabelTextColor = [UIColor whiteColor];
    pinSuccessNotification.notificationLabel.textAlignment = NSTextAlignmentCenter;
    pinSuccessNotification.notificationLabelHeight = 30;
    pinSuccessNotification.notificationLabelFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:17];
    [pinSuccessNotification displayNotificationWithMessage:successMessage forDuration:0.7];
}

@end
