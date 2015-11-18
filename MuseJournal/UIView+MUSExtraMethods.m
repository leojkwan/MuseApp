//
//  UIView+MUSExtraMethods.m
//  Muse
//
//  Created by Leo Kwan on 10/27/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "UIView+MUSExtraMethods.h"

@implementation UIView (MUSExtraMethods)

-(void)fadeInWithDuration:(NSTimeInterval)duration withCompletion:(void (^) (BOOL))completion {
    // start invisible
    self.alpha= 0;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.alpha = 1;
                     }
     
                     completion:^(BOOL finished){
                         if (completion) {
                             completion(finished);
                         }
                     }];
}

@end
