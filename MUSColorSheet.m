//
//  MUSColorSheet.m
//  MuseApp
//
//  Created by Leo Kwan on 9/24/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSColorSheet.h"
#import "UIColor+MUSColors.h"


@implementation MUSColorSheet

+ (MUSColorSheet *)sharedInstance {
    static dispatch_once_t onceToken;
    static MUSColorSheet *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[MUSColorSheet alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _iconTint = [UIColor MUSgreenColor];
    }
    return self;
}



@end
