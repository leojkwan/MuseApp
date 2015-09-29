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



@end
