//
//  Song+MUSExtraMethods.h
//  MuseApp
//
//  Created by Leo Kwan on 9/21/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "Song.h"

@interface Song (MUSExtraMethods)

+(instancetype)initWithTitle:(NSString *)trackName artist:(NSString*)artist genre:(NSString *)genre album:(NSString *)albumTitle inManagedObjectContext:(NSManagedObjectContext *)context;

@end
