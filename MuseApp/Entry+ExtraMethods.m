//
//  Entry+ExtraMethods.m
//  MuseApp
//
//  Created by Leo Kwan on 8/28/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "Entry+ExtraMethods.h"

@implementation Entry (ExtraMethods)

+(NSString *)getTitleOfContentFromText:(NSString*)content {
    NSString *titleString = [[content componentsSeparatedByString:@"\n"] objectAtIndex:0];
    return titleString;
}

@end

