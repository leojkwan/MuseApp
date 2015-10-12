//
//  NSAttributedString+MUSExtraMethods.m
//  MuseApp
//
//  Created by Leo Kwan on 9/18/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "NSAttributedString+MUSExtraMethods.h"
#import <markdown_lib.h>
#import <markdown_peg.h>
#import "UIFont+MUSFonts.h"

@implementation NSAttributedString (MUSExtraMethods)

+(NSAttributedString *)returnMarkDownStringFromString:(NSString *)string {
    NSMutableAttributedString* attributedContent = markdown_to_attr_string(string,0,[UIFont returnFontsForAttributedString]);
    return attributedContent;
}


+(NSAttributedString *)returnAttrTagWithTitle:(NSString *)title color:(UIColor *)color undelineColor:(UIColor *)lineColor{
    NSMutableAttributedString *attrTag = [[NSMutableAttributedString alloc ]initWithString:title];
    [attrTag addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:(NSUnderlineStyleThick)] range:NSMakeRange(0, [attrTag length])];
    [attrTag addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [attrTag length])];
    UIFont *tagFont=  [UIFont fontWithName:@"ADAM.CGPRO" size:10.0];
    [attrTag addAttribute:NSFontAttributeName value:tagFont range:NSMakeRange(0, [attrTag length])];
    [attrTag addAttribute:NSUnderlineColorAttributeName value:lineColor range:NSMakeRange(0, [attrTag length])];
    return attrTag;
}

+(NSAttributedString *)returnAutoPlayButtonText:(BOOL)on {
    
    
    
    NSMutableAttributedString *autoplayString = [[NSMutableAttributedString alloc ]initWithString:@"autoplay: "];
    UIFont *autoplayFont=  [UIFont fontWithName:@"ADAM.CGPRO" size:12.0];
    [autoplayString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, [autoplayString length])];
    [autoplayString addAttribute:NSFontAttributeName value:autoplayFont range:NSMakeRange(0, [autoplayString length])];
    
    
    NSMutableAttributedString *_switchString;
    
    if (on) {
        _switchString = [[NSMutableAttributedString alloc ]initWithString:@"ON"];
        [_switchString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, [_switchString length])];
    }    else {
        _switchString = [[NSMutableAttributedString alloc ]initWithString:@"OFF"];
        [_switchString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, [_switchString length])];
        
    }
    
    
    UIFont *switchStringFont=  [UIFont fontWithName:@"Raleway-SemiBold" size:15.0];
    [_switchString addAttribute:NSFontAttributeName value:switchStringFont range:NSMakeRange(0, [_switchString length])];
    
    NSMutableAttributedString *appendedAutoPlayString = [[NSMutableAttributedString alloc] init];
    [appendedAutoPlayString appendAttributedString:autoplayString];
    [appendedAutoPlayString appendAttributedString:_switchString];
    
    return appendedAutoPlayString;
    
}

@end
