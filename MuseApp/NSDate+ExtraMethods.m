//
//  NSDate+ExtraMethods.m
//  MuseApp
//
//  Created by Leo Kwan on 8/28/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "NSDate+ExtraMethods.h"

@implementation NSDate (ExtraMethods)

-(NSString *)returnMonthAndYear{
    NSDateFormatter *monthAndYearFormatter = [[NSDateFormatter alloc] init];
    [monthAndYearFormatter setDateFormat:@"MMMM YYYY"];
    NSString *monthAndYearOfSection = [monthAndYearFormatter stringFromDate:self];
    return monthAndYearOfSection;
}

-(NSString *)returnDayMonthDateFromDate{
    NSDateFormatter *monthAndYearFormatter = [[NSDateFormatter alloc] init];
    [monthAndYearFormatter setDateFormat:@"EEEE, MMMM dd"];
    NSString *dayMonthDate = [monthAndYearFormatter stringFromDate:self];
    return dayMonthDate;
}

@end
