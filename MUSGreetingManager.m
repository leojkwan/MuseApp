//
//  MUSGreetingManager.m
//  MuseApp
//
//  Created by Leo Kwan on 9/24/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSGreetingManager.h"


@implementation MUSGreetingManager

-(instancetype)initWithTimeOfDay:(TimeOfDay)time firstName:(NSString *)name {

    self = [super init];
    if (self) {
        [self greetByTimeOfDay:time firstName:name];
    }
    return self;
}

-(void)greetByTimeOfDay:(TimeOfDay)time firstName:(NSString*)name{
    
    switch (time) {
        case Morning:
            if (name)
                self.usergreeting = [NSString stringWithFormat:@"Good Morning %@!", name];
             else
                 self.usergreeting = @"Good Morning!";
            break;
            
        case Afternoon:
            if (name)
                self.usergreeting = [NSString stringWithFormat:@"Good Afternoon %@!", name];
            else
                self.usergreeting = @"Good Afternoon!";
            break;
            
        case Evening:
            if (name)
                self.usergreeting = [NSString stringWithFormat:@"Good Evening %@.", name];
            else
                self.usergreeting = @"Good Evening.";
            break;
            
        default:
            if (name)
                self.usergreeting = [NSString stringWithFormat:@"It's late night %@.", name];
            else
                self.usergreeting = @"It's late night.";
            break;
    }
}

@end
