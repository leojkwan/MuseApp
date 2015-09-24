//
//  UIFont+MUSFonts.m
//  MuseApp
//
//  Created by Leo Kwan on 9/18/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "UIFont+MUSFonts.h"
#import <markdown_peg.h>
#import <markdown_lib.h>

@implementation UIFont (MUSFonts)

+(NSMutableDictionary *)returnFontsForAttributedString{
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];

    
    // PARAGRAPH FONT
    // p
    UIFont *paragraphFont = [UIFont fontWithName:@"AvenirNext-Medium" size:18.0];
    
    NSMutableParagraphStyle* pParagraphStyle = [[NSMutableParagraphStyle alloc]init];

    pParagraphStyle.paragraphSpacing = 12;
    pParagraphStyle.paragraphSpacingBefore = 12;
    NSDictionary *pAttributes = @{
                                  NSFontAttributeName : paragraphFont,
                                  NSParagraphStyleAttributeName : pParagraphStyle,
                                  };
    
    [attributes setObject:pAttributes forKey:@(PARA)];
    
    // h1
    UIColor *h1Color = [UIColor darkGrayColor];
    UIFont *h1Font = [UIFont fontWithName:@"AvenirNext-Bold" size:24.0];
    NSDictionary *h1Attributes = @{
                                  NSFontAttributeName : h1Font,
                                  NSForegroundColorAttributeName : h1Color
                                  };
    [attributes setObject:h1Attributes forKey:@(H1)];
    
    // h2
    UIFont *h2Font = [UIFont fontWithName:@"AvenirNext-Bold" size:18.0];
    [attributes setObject:@{NSFontAttributeName : h2Font} forKey:@(H2)];
    
    // h3
    UIFont *h3Font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:17.0];
    [attributes setObject:@{NSFontAttributeName : h3Font} forKey:@(H3)];

    
    // em
    UIFont *emFont = [UIFont fontWithName:@"AvenirNext-MediumItalic" size:18.0];
    [attributes setObject:@{NSFontAttributeName : emFont} forKey:@(EMPH)];
    
    
    // strong
    UIFont *strongFont = [UIFont fontWithName:@"AvenirNext-Heavy" size:18.0];
    [attributes setObject:@{NSFontAttributeName : strongFont} forKey:@(STRONG)];

    // HORIZONTAL RULE

    UIFont *ruleFont = [UIFont fontWithName:@"AvenirNext-Heavy" size:10.0];
    [attributes setObject:@{NSFontAttributeName : ruleFont} forKey:@(HRULE)];
    
    // PARAGRAPH STYLE
    
    // ul
    NSMutableParagraphStyle* listParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    listParagraphStyle.headIndent = 16.0;
    [attributes setObject:@{NSFontAttributeName : paragraphFont, NSParagraphStyleAttributeName : listParagraphStyle} forKey:@(BULLETLIST)];
    
    // hrule
    NSMutableParagraphStyle* horizontalParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    [horizontalParagraphStyle setAlignment:NSTextAlignmentCenter];
    [attributes setObject:@{NSFontAttributeName : ruleFont, NSParagraphStyleAttributeName : horizontalParagraphStyle} forKey:@(HRULE)];

    
    // li
    NSMutableParagraphStyle* listItemParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    listItemParagraphStyle.headIndent = 16.0;
    [attributes setObject:@{NSFontAttributeName : paragraphFont, NSParagraphStyleAttributeName : listItemParagraphStyle} forKey:@(LISTITEM)];
    
    
    // blockquote
    NSMutableParagraphStyle* blockquoteParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    blockquoteParagraphStyle.headIndent = 16.0;
    blockquoteParagraphStyle.tailIndent = 16.0;
    blockquoteParagraphStyle.firstLineHeadIndent = 16.0;
    [attributes setObject:@{NSFontAttributeName : [emFont fontWithSize:18.0], NSParagraphStyleAttributeName : pParagraphStyle} forKey:@(BLOCKQUOTE)];

    
    return attributes;
    }

+(UIFont *)returnFontsForDefaultString {
   return [UIFont fontWithName:@"AvenirNext-Medium" size:18.0];
}

@end
