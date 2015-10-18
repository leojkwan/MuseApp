//
//  MUSiPhoneSizeManager.m
//  Pods
//
//  Created by Leo Kwan on 10/18/15.
//
//

#import "MUSiPhoneSizeManager.h"

@implementation MUSiPhoneSizeManager

+(BOOL)isIPhone4SAndSmaller {
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height <= 480)
        return YES;         // iPhone Classic
    else
        return NO;
}

@end
