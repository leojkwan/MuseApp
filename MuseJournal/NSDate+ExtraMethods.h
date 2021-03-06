//
//  NSDate+ExtraMethods.h
//  MuseApp
//
//  Created by Leo Kwan on 8/28/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ExtraMethods)

-(NSString *)returnMonthAndYear;
-(NSString *)monthDateAndYearString;
-(NSString *)returnDayMonthDateFromDate;
-(NSDate *)monthDateYearDate;

-(NSString *)returnEntryDateStringForDate:(NSDate *)date;
-(NSString *)numericMonthDateAndYearString;

@end
