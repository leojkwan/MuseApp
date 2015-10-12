//
//  NSDate+ExtraMethods.m
//  MuseApp
//
//  Created by Leo Kwan on 8/28/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "NSDate+ExtraMethods.h"
#import "MUSTimeFetcher.h"

@implementation NSDate (ExtraMethods)

-(NSString *)returnMonthAndYear{
    NSDateFormatter *monthAndYearFormatter = [[NSDateFormatter alloc] init];
    [monthAndYearFormatter setDateFormat:@"MMMM YYYY"];
    NSString *monthAndYearOfSection = [monthAndYearFormatter stringFromDate:self];
    return monthAndYearOfSection;
}

-(NSString *)monthDateAndYearString{
    NSDateFormatter *monthAndYearFormatter = [[NSDateFormatter alloc] init];
    [monthAndYearFormatter setDateFormat:@"MMMM dd YYYY"];
    NSString *monthAndYearOfSection = [monthAndYearFormatter stringFromDate:self];
    return monthAndYearOfSection;
}

-(NSString *)numericMonthDateAndYearString{
    NSDateFormatter *monthAndYearFormatter = [[NSDateFormatter alloc] init];
    [monthAndYearFormatter setDateFormat:@"MM.dd.YYYY"];
    NSString *numericMonthAndYearOfEntry = [monthAndYearFormatter stringFromDate:self];
    return numericMonthAndYearOfEntry;
}


-(NSDate *)monthDateYearDate{
    NSDateFormatter *monthAndYearFormatter = [[NSDateFormatter alloc] init];
    [monthAndYearFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *monthAndYearOfSection = [monthAndYearFormatter stringFromDate:self];
    NSDate *shorterDate = [monthAndYearFormatter dateFromString: monthAndYearOfSection];
    return shorterDate;
}

-(NSString *)returnDayMonthDateFromDate{
    NSDateFormatter *monthAndYearFormatter = [[NSDateFormatter alloc] init];
    [monthAndYearFormatter setDateFormat:@"EEEE, MMMM dd"];
    NSString *dayMonthDate = [monthAndYearFormatter stringFromDate:self];
    return dayMonthDate;
}


-(NSString *)returnEntryDateStringForDate:(NSDate *)date{
    
    MUSTimeFetcher *timeFetcher = [[MUSTimeFetcher alloc] init];
    TimeOfDay timeOfEntry = [timeFetcher getTimeOfDayForDate:date];
    
    NSString *_timeOfDay;
    
    switch (timeOfEntry) {
        case Morning:
            _timeOfDay = @"Morning";
            break;
        case Afternoon:
            _timeOfDay = @"Afternoon";
            break;
        case Evening:
            _timeOfDay = @"Evening";
            break;
        case LateNight:
            _timeOfDay = @"Late Night";
            break;
        default:
            break;
    }
    
    NSDateFormatter *dayOfWeekFormatter = [[NSDateFormatter alloc] init];
    [dayOfWeekFormatter setDateFormat:@"EEEE"];
    NSString *dayOfWeek = [dayOfWeekFormatter stringFromDate:date];

    NSDateFormatter *clockFormatter = [[NSDateFormatter alloc] init];
    [clockFormatter setTimeStyle: NSDateFormatterShortStyle];
    NSString *clockTime = [clockFormatter stringFromDate: date];
    
    NSString *entryDateStringForDate = [NSString stringWithFormat:@"%@ %@, %@", dayOfWeek, _timeOfDay, clockTime];
    return entryDateStringForDate;
}




@end
