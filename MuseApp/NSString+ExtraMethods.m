//
//  NSString+ExtraMethods.m
//  MuseApp
//
//  Created by Leo Kwan on 8/28/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "NSString+ExtraMethods.h"

@implementation NSString (ExtraMethods)

+(NSString *)returnFormattedDateStringWithDate:(NSDate *)date {
    
    NSDateFormatter *monthAndYearFormatter = [[NSDateFormatter alloc] init];
    [monthAndYearFormatter setDateFormat:@"MMMM YYYY"];
    
    NSString *monthAndYearOfSection = [monthAndYearFormatter stringFromDate:date];
    
    
    return monthAndYearOfSection;
}



@end
