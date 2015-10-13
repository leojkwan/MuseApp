//
//  MUSAutoPlayManager.m
//  Muse
//
//  Created by Leo Kwan on 10/12/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSAutoPlayManager.h"

@implementation MUSAutoPlayManager

+(BOOL)returnAutoPlayStatus {
    BOOL autoplayStatus = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoplay"];
    if (autoplayStatus)
        return YES;
    else
        return NO;
}

@end
