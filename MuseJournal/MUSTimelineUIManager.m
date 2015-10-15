//
//  MUSTimelineUIManager.m
//  Muse
//
//  Created by Leo Kwan on 10/15/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSTimelineUIManager.h"



@implementation MUSTimelineUIManager

+(UILabel *)returnSectionLabelWithFrame:(CGRect)sectionFrame fontColor:(UIColor*)color backgroundColor:(UIColor *)bgColor {
    UILabel *sectionLabel = [[UILabel alloc] init];
    sectionLabel.frame = sectionFrame;
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    [sectionLabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:13.0]];
    sectionLabel.textColor = color;
    sectionLabel.backgroundColor = bgColor;
    return sectionLabel;
}

@end
