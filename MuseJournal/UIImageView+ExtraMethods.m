//
//  UIImageView+ExtraMethods.m

#import "UIImageView+ExtraMethods.h"

@implementation UIImageView (ExtraMethods)


-(void)setImageToColorTint:(UIColor *)tint {
    self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setTintColor:tint];
}

@end
