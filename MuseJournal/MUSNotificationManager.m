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

@end
