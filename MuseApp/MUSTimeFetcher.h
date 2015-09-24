//
//  MUSTimeFetcher.h
//  MuseApp
//
//  Created by Leo Kwan on 9/23/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    Morning,
    Afternoon,
    Evening
} TimeOfDay;

@protocol  CurrentTimeDelegate <NSObject>
-(void)updatedTime:(NSString*)timeString;
@end

@interface MUSTimeFetcher : NSObject

@property (nonatomic, assign) id <CurrentTimeDelegate> delegate;
@property (nonatomic, assign) TimeOfDay timeOfDay;
@property (strong, nonatomic) NSString *currentTime;

//-(NSArray*) getIconsForTimeOfDay

@end
