//
//  UIFont+MUSFonts.h
//  MuseApp
//
//  Created by Leo Kwan on 9/18/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (MUSFonts)

+(NSMutableDictionary *)returnFontsForAttributedString;
+(UIFont *)returnParagraphFont;
+(UIFont *)returnEntryTitleFont;
+(UIFont *)returnSystemsFont;
+(UIFont *)returnHeaderTitleFont;


@end
