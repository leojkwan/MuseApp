//
//  NSAttributedString+MUSExtraMethods.h
//  MuseApp
//
//  Created by Leo Kwan on 9/18/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (MUSExtraMethods)

+(NSAttributedString *)returnMarkDownStringFromString:(NSString *)string;
+(NSAttributedString *)returnAttrTagWithTitle:(NSString *)title color:(UIColor *)color undelineColor:(UIColor *)lineColor;
+(NSAttributedString *)returnStringWithTitle:(NSString *)title color:(UIColor *)color undelineColor:(UIColor *)lineColor fontSize:(CGFloat)size;
@end
