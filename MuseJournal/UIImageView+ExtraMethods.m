//
//  UIImageView+ExtraMethods.m
//  
//
//  Created by Leo Kwan on 9/30/15.
//
//

#import "UIImageView+ExtraMethods.h"

@implementation UIImageView (ExtraMethods)


-(void)setImageToColorTint:(UIColor *)tint {
    self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setTintColor:tint];
}

@end
