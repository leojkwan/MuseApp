//
//  MUSCircleGradient.m
//  MuseApp
//
//  Created by Leo Kwan on 8/28/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "MUSCircleGradient.h"

@implementation MUSCircleGradient

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.layer.contents = (__bridge id)([[self generateRadial]CGImage]);
    }
    
    return self;
}

-(UIImage*)generateRadial{
    
    //Define the gradient ----------------------
    CGGradientRef gradient;
    CGColorSpaceRef colorSpace;
    size_t locations_num = 5;
    
    CGFloat locations[5] = {0.0,0.4,0.5,0.6,1.0};
    
    CGFloat components[20] = {  1.0, 0.0, 0.0, 0.2,
        1.0, 0.0, 0.0, 1,
        1.0, 0.0, 0.0, 0.8,
        1.0, 0.0, 0.0, 0.4,
        1.0, 0.0, 0.0, 0.0
    };
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    gradient = CGGradientCreateWithColorComponents (colorSpace, components,
                                                    locations, locations_num);
    
    
    //Define Gradient Positions ---------------
    
    //We want these exactly at the center of the view
    CGPoint startPoint, endPoint;
    
    //Start point
    startPoint.x = self.frame.size.width/2;
    startPoint.y = self.frame.size.height/2;
    
    //End point
    endPoint.x = self.frame.size.width/2;
    endPoint.y = self.frame.size.height/2;
    
    //Generate the Image -----------------------
    //Begin an image context
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    //Use CG to draw the radial gradient into the image context
    CGContextDrawRadialGradient(imageContext, gradient, startPoint, 0, endPoint, self.frame.size.width/2, 0);
    //Get the image from the context
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
