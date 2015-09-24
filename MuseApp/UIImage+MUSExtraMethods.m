//
//  UIImage+MUSExtraMethods.m
//  MuseApp
//
//  Created by Leo Kwan on 9/20/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "UIImage+MUSExtraMethods.h"

@implementation UIImage (MUSExtraMethods)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)makeImageTemplate{
    [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@end
