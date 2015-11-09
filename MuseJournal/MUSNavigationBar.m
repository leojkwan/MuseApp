//
//  MUSNavigationBar.m
//  Muse
//
//  Created by Leo Kwan on 11/8/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSNavigationBar.h"

@implementation MUSNavigationBar

- (void) setNormalHeight{
    if (self.height != 44.0f){
        self.height = 44.0f;
        CGRect oldFrame = 	self.frame;
        oldFrame.size.height = self.height;
        self.frame = oldFrame;
        [self setNeedsDisplay];
    }
    self.hidden=false;
}

@end
