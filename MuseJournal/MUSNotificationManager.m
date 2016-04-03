//
//  MUSNotificationManager.m
//  Muse
//
//  Created by Leo Kwan on 10/6/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSNotificationManager.h"
#import <CWStatusBarNotification.h>

@implementation MUSNotificationManager

+(void)displayNotificationWithMessage:(NSString *)message backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor {
    CWStatusBarNotification *pinSuccessNotification = [CWStatusBarNotification new];
    pinSuccessNotification.notificationStyle = CWNotificationStyleStatusBarNotification;
    pinSuccessNotification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
    pinSuccessNotification.notificationAnimationOutStyle = CWNotificationAnimationStyleBottom;
    
    pinSuccessNotification.notificationLabelTextColor = textColor;
    pinSuccessNotification.notificationLabelBackgroundColor = backgroundColor;
    pinSuccessNotification.notificationLabel.textAlignment = NSTextAlignmentCenter;
    pinSuccessNotification.notificationLabelHeight = 30;
    pinSuccessNotification.notificationLabelFont = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
    [pinSuccessNotification displayNotificationWithMessage:message forDuration:0.7];
}


+(void)selectNotificationForSong:(NSString *)title musicStatus:(PlayerStatus)status {

if (status == NotPlaying){
    [MUSNotificationManager displayNotificationWithMessage:@"Play a song to pin!" backgroundColor:[UIColor grayColor] textColor:[UIColor whiteColor]];
} else if(status == Invalid) {
    [MUSNotificationManager displayNotificationWithMessage:@"Song not locally owned. Download on Apple Music! " backgroundColor:[UIColor yellowColor] textColor:[UIColor blackColor]];
} else if(status == Playing) {
    [MUSNotificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"Successfully Pinned '%@'", title] backgroundColor:[UIColor colorWithRed:0.21 green:0.72 blue:0.00 alpha:1.0] textColor:[UIColor whiteColor]];
} else if(status == AlreadyPinned) {
    [MUSNotificationManager displayNotificationWithMessage:[NSString stringWithFormat:@"%@ is already pinned!", title] backgroundColor:[UIColor colorWithRed:0.98 green:0.21 blue:0.37 alpha:1]textColor:[UIColor whiteColor]];
}
}

@end
