//
//  MUSTagManager.m
//  Muse
//
//  Created by Leo Kwan on 10/14/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//


#import "MUSTagManager.h"
#import "UIColor+MUSColors.h"
#import <UIKit/UIKit.h>

@implementation MUSTagManager

+(NSAttributedString *)returnAttributedStringForTag:(NSString*)mood {
    
    if ([mood isEqualToString:@"Happy"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor MUSMistyIce]];
    else if ([mood isEqualToString:@"Determined"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor MUSBloodOrange]];
    else if ([mood isEqualToString:@"Disappointed"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor MUSDanube]];
    else if ([mood isEqualToString:@"Relaxed"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor MUSCorn]];
    else if ([mood isEqualToString:@"Dashing"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor MUSPurpleG]];
    else if ([mood isEqualToString:@"Exhausted"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor MUSPolar]];
    else if ([mood isEqualToString:@"Rejected"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor MUSSolitude]];
    else if ([mood isEqualToString:@"Energized"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor MUSGreenMachine]];
    else if ([mood isEqualToString:@"Festive"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor MUSCherokeeSun]];
    else if ([mood isEqualToString:@"Frustrated"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor MUSBigStone]];
    else if ([mood isEqualToString:@"Party"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor MUSElectricMacaroni]];
    else if ([mood isEqualToString:@"Hyped"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor MUSRebeccaAlmond]];
    else if ([mood isEqualToString:@"Hustlin"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor MUSSuperYellow]];
    else if ([mood isEqualToString:@"Romantic"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor MUSBubbleGumRose]];

    // DEFAULT IS TO RETURN MOOD IN DARK GRAY
    return [self returnMoodString:mood withUnderlineColor:[UIColor darkGrayColor]];
}

+(NSAttributedString *)returnMoodString:(NSString *)moodString withUnderlineColor:(UIColor *)color{
    
    NSMutableAttributedString *attrTag = [[NSMutableAttributedString alloc] initWithString:moodString];
    [attrTag addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:(NSUnderlineStyleThick)] range:NSMakeRange(0, [attrTag length])];
    [attrTag addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, [attrTag length])];
    
    UIFont *tagFont=  [UIFont fontWithName:@"SemplicitaPro-Medium" size:14.0];
    [attrTag addAttribute:NSFontAttributeName value:tagFont range:NSMakeRange(0, [attrTag length])];
    [attrTag addAttribute:NSKernAttributeName value: @(0.75f) range:NSMakeRange(0, [attrTag length])]; // Horizontal Character spacing
    [attrTag addAttribute:NSUnderlineColorAttributeName value:color range:NSMakeRange(0, [attrTag length])];
    return attrTag;
}

+(NSArray *)returnArrayForTagImages {
    return  @[
              @[@"Happy", [UIImage imageNamed:@"moodHappy"]],
              @[@"Determined", [UIImage imageNamed:@"moodDetermined"]],
              @[@"Disappointed", [UIImage imageNamed:@"moodDisappointed"]],
              @[@"Relaxed", [UIImage imageNamed:@"moodRelaxed"]],
              @[@"Dashing", [UIImage imageNamed:@"moodDashing"]],
                @[@"Exhausted", [UIImage imageNamed:@"moodExhausted"]],
              @[@"Rejected", [UIImage imageNamed:@"moodRejected"]],
              @[@"Energized", [UIImage imageNamed:@"moodEnergized"]],
              @[@"Festive", [UIImage imageNamed:@"moodFestive"]],
              @[@"Frustrated", [UIImage imageNamed:@"moodFrustrated"]],
              @[@"Party", [UIImage imageNamed:@"moodParty"]],
              @[@"Hyped", [UIImage imageNamed:@"moodHyped"]],
              @[@"Hustlin'", [UIImage imageNamed:@"moodHustlin"]],
              @[@"Romantic", [UIImage imageNamed:@"moodRomantic"]]
              ];
}
@end
