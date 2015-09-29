//
//  MUSGreetingManager.h
//  MuseApp
//
//  Created by Leo Kwan on 9/24/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUSTimeFetcher.h"
@interface MUSGreetingManager : NSObject


-(instancetype)initWithTimeOfDay:(TimeOfDay)time firstName:(NSString *)name;

@property (strong, nonatomic) NSString* usergreeting;

@end
