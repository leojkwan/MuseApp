//
//  MUSTagManager.m
//  Muse
//
//  Created by Leo Kwan on 10/14/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//


#import "MUSTagManager.h"
#import <UIKit/UIKit.h>

@implementation MUSTagManager

+(NSAttributedString *)returnAttributedStringForTag:(NSString*)mood {
    
    if ([mood isEqualToString:@"Happy"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor magentaColor]];
    else if ([mood isEqualToString:@"Excited"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor magentaColor]];
    else if ([mood isEqualToString:@"Romantic"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor magentaColor]];
    else if ([mood isEqualToString:@"Festive"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor magentaColor]];
    else if ([mood isEqualToString:@"Celebratory"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor magentaColor]];
    else if ([mood isEqualToString:@"Confident"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor magentaColor]];
    else if ([mood isEqualToString:@"Frustrated"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor magentaColor]];
    else if ([mood isEqualToString:@"Disappointed"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor magentaColor]];
    else if ([mood isEqualToString:@"Rejected"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor magentaColor]];
    else if ([mood isEqualToString:@"Hyped"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor magentaColor]];
    else if ([mood isEqualToString:@"Chill"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor magentaColor]];
    else if ([mood isEqualToString:@"Sleepy"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor magentaColor]];
    else if ([mood isEqualToString:@"Hustlin'"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor magentaColor]];
    else if ([mood isEqualToString:@"Discouraged"])
        return [self returnMoodString:mood withUnderlineColor:[UIColor magentaColor]];

    // DEFAULT IS TO RETURN MOOD IN DARK GRAY
    return [self returnMoodString:mood withUnderlineColor:[UIColor darkGrayColor]];
}

+(NSAttributedString *)returnMoodString:(NSString *)moodString withUnderlineColor:(UIColor *)color{
    
    NSMutableAttributedString *attrTag = [[NSMutableAttributedString alloc] initWithString:moodString];
    [attrTag addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:(NSUnderlineStyleThick)] range:NSMakeRange(0, [attrTag length])];
    [attrTag addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, [attrTag length])];
    
    UIFont *tagFont=  [UIFont fontWithName:@"ADAM.CGPRO" size:12.0];
    [attrTag addAttribute:NSFontAttributeName value:tagFont range:NSMakeRange(0, [attrTag length])];
    [attrTag addAttribute:NSUnderlineColorAttributeName value:color range:NSMakeRange(0, [attrTag length])];
    return attrTag;
}

+(NSArray *)returnArrayForTagImages {
    return  @[
              @[@"partyMood", [UIImage imageNamed:@"partyMood"]]

//              @[@"Chill", [UIImage imageNamed:@"Chill"]],
//              @[@"Celebratory", [UIImage imageNamed:@"Celebratory"]],
//              @[@"Confident", [UIImage imageNamed:@"Confident"]],
//              @[@"Discouraged", [UIImage imageNamed:@"Discouraged"]],
//              @[@"Disappointed", [UIImage imageNamed:@"Disappointed"]],
//              @[@"Excited", [UIImage imageNamed:@"Excited"]],
//              @[@"Festive", [UIImage imageNamed:@"Festive"]],
//              @[@"Frustrated", [UIImage imageNamed:@"Frustrated"]],
//              @[@"Happy", [UIImage imageNamed:@"Happy"]],
//              @[@"Hyped", [UIImage imageNamed:@"Hyped"]],
//              @[@"Hustlin", [UIImage imageNamed:@"Hustlin"]],
//              @[@"Romantic", [UIImage imageNamed:@"Romantic"]],
//              @[@"Rejected", [UIImage imageNamed:@"Rejected"]],
//              @[@"Sleepy", [UIImage imageNamed:@"Sleepy"]],
              ];
}
@end
