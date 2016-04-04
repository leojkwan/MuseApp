//
//  UIFont+MUSFonts.m
//  MuseApp

#import "UIFont+MUSFonts.h"
#import <markdown_peg.h>
#import <markdown_lib.h>

@implementation UIFont (MUSFonts)

+(NSMutableDictionary *)returnFontsForAttributedString{
  
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
  
  // PARAGRAPH FONT
  
  UIFont *paragraphFont = [UIFont fontWithName:@"Avenir" size:18.0];
  UIColor *pColor = [UIColor blackColor];
  NSMutableParagraphStyle* pParagraphStyle = [[NSMutableParagraphStyle alloc]init];
  pParagraphStyle.paragraphSpacing = 12;
  pParagraphStyle.lineSpacing = 10;
  pParagraphStyle.paragraphSpacingBefore = 12;
  NSDictionary *pAttributes = @{
                                NSFontAttributeName : paragraphFont,
                                NSParagraphStyleAttributeName : pParagraphStyle,
                                NSForegroundColorAttributeName : pColor
                                };
  
  [attributes setObject:pAttributes forKey:@(PARA)];
  
  // h1
  UIColor *h1Color = [UIColor blackColor];
  UIFont *h1Font = [UIFont fontWithName:@"SemplicitaPro-Medium" size:25.0];
  NSMutableParagraphStyle* h1Style = [[NSMutableParagraphStyle alloc]init];
  h1Style.alignment = NSTextAlignmentJustified;
  NSDictionary *h1Attributes = @{
                                 NSFontAttributeName : h1Font,
                                 NSForegroundColorAttributeName : h1Color,
                                 NSParagraphStyleAttributeName:h1Style
                                 };
  [attributes setObject:h1Attributes forKey:@(H1)];
  
  
  
  // h2
  UIFont *h2Font = [UIFont fontWithName:@"SemplicitaPro-Medium" size:22.0];
  
  NSDictionary *h2Attributes = @{
                                 NSFontAttributeName : h2Font,
                                 NSForegroundColorAttributeName : h1Color,
                                 NSParagraphStyleAttributeName:h1Style
                                 };
  
  [attributes setObject:h2Attributes forKey:@(H2)];
  
  // h3
  UIFont *h3Font = [UIFont fontWithName:@"SemplicitaPro-Medium" size:22.0];
  [attributes setObject:@{NSFontAttributeName : h3Font} forKey:@(H3)];
  
  // em
  UIFont *emFont = [UIFont fontWithName:@"Futura-MediumItalic" size:21.0];
  [attributes setObject:@{NSFontAttributeName : emFont} forKey:@(EMPH)];
  
  
  // strong
  UIFont *strongFont = [UIFont fontWithName:@"SemplicitaPro-Medium" size:21.0];
  [attributes setObject:@{NSFontAttributeName : strongFont} forKey:@(STRONG)];
  
  
  // HORIZONTAL RULE
  
  UIFont *ruleFont = [UIFont fontWithName:@"AvenirNext-Heavy" size:10.0];
  [attributes setObject:@{NSFontAttributeName : ruleFont} forKey:@(HRULE)];
  
  // PARAGRAPH STYLE
  
  // ul
  NSMutableParagraphStyle* bulletListParagraphStyle = [[NSMutableParagraphStyle alloc]init];
  bulletListParagraphStyle.headIndent = 16.0;
  [attributes setObject:@{NSFontAttributeName : paragraphFont, NSParagraphStyleAttributeName : bulletListParagraphStyle} forKey:@(BULLETLIST)];
  
  // hrule
  NSMutableParagraphStyle* horizontalParagraphStyle = [[NSMutableParagraphStyle alloc]init];
  [attributes setObject:@{NSFontAttributeName : ruleFont, NSParagraphStyleAttributeName : horizontalParagraphStyle} forKey:@(HRULE)];
  
  
  // li
  NSMutableParagraphStyle* listItemParagraphStyle = [[NSMutableParagraphStyle alloc]init];
  listItemParagraphStyle.headIndent = 16.0;
  [attributes setObject:@{NSFontAttributeName : paragraphFont, NSParagraphStyleAttributeName : listItemParagraphStyle} forKey:@(ORDEREDLIST)];
  
  // listitem
  NSMutableParagraphStyle* listParagraphStyle = [[NSMutableParagraphStyle alloc]init];
  listItemParagraphStyle.headIndent = 16.0;
  [attributes setObject:@{NSFontAttributeName : paragraphFont, NSParagraphStyleAttributeName : listParagraphStyle} forKey:@(LIST)];
  
  
  UIFont *blockFont = [UIFont fontWithName:@"Futura-MediumItalic" size:18.0];
  
  
  [attributes setObject:@{NSFontAttributeName : blockFont, NSParagraphStyleAttributeName : h1Style, NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle), NSUnderlineColorAttributeName : [UIColor grayColor]} forKey:@(BLOCKQUOTE)];
  
  
  return attributes;
}

+(UIFont *)returnParagraphFont {
  return [UIFont fontWithName:@"Avenir" size:18.0];
}

+(UIFont *)returnEntryTitleFont {
  return [UIFont fontWithName:@"SemplicitaPro-Medium" size:18.0];
}

+(UIFont *)returnSystemsFont {
  return [UIFont fontWithName:@"Avenir" size:18.0];
}

+(UIFont *)returnHeaderTitleFont {
  return  [UIFont fontWithName:@"ADAM.CGPRO" size:15.0];
}


@end
