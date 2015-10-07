//
//  MUSNotificationManager.h
//  Muse
//
//  Created by Leo Kwan on 10/6/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MUSNotificationManager : NSObject

+(void)displayNotificationWithMessage:(NSString *)message backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor;


@end
