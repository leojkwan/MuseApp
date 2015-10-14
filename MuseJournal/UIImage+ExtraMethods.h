//
//  UIImage+ExtraMethods.h
//  Muse
//
//  Created by Leo Kwan on 9/30/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ExtraMethods)

- (UIImage*) blur:(UIImage*)theImage;
+(UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color;


@end
