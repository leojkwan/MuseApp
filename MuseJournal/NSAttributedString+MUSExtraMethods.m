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




@end
