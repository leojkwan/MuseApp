//
//  MUSIconAnimation.m
//  MuseApp
//
//  Created by Leo Kwan on 8/30/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "MUSIconAnimation.h"


@implementation MUSIconAnimation

-(instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        NSArray *imageNames = @[@"icon1", @"icon2", @"icon3", @"icon4", @"icon5"];
        
        _images = [[NSMutableArray alloc] init];
        for (int i = 0; i < imageNames.count; i++) {
            [_images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
        }
         
        // set image array to my animation property
        self.animationImages = _images;
        self.animationDuration = 1.2;
    }
    return self;
}

@end
