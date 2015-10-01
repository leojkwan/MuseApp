//
//  MUSTimeFetcher.m
//  MuseApp
//
//  Created by Leo Kwan on 9/23/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSTimeFetcher.h"

@interface MUSTimeFetcher ()
@property(strong, nonatomic)  NSDateFormatter *dateFormatter;
@end

@implementation MUSTimeFetcher

-(instancetype)init{
    self = [super init];
    
    if (self) {
        _timeOfDay = [self getTimeOfDayForDate:[NSDate date]];
        
        [NSTimer scheduledTimerWithTimeInterval:0.2
                                         target:self
                                       selector:@selector(getCurrentTime)
                                       userInfo:nil
                                        repeats:YES];
    }
    return self;
}

-(void)getCurrentTime {
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeStyle: NSDateFormatterShortStyle];
    NSString *currentTime = [self.dateFormatter stringFromDate: [NSDate date]];
    [self.delegate updatedTime:currentTime];
}


-(TimeOfDay)getTimeOfDayForDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:date];
    NSInteger hour = [components hour];
    if(hour > 3 && hour < 12)
        return Morning;
    else if(hour >= 12 && hour < 17)
        return Afternoon;
    else if (hour >= 17 && hour < 23) {
        return Evening;
    } else
    return LateNight;
}


@end
