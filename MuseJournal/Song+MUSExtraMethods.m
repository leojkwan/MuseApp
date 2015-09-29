//
//  Song+MUSExtraMethods.m
//  MuseApp
//
//  Created by Leo Kwan on 9/21/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "Song+MUSExtraMethods.h"

@implementation Song (MUSExtraMethods)

+(instancetype)initWithTitle:(NSString *)trackName artist:(NSString*)artist genre:(NSString *)genre album:(NSString *)albumTitle inManagedObjectContext:(NSManagedObjectContext *)context{

        Song* song = (Song*)[NSEntityDescription insertNewObjectForEntityForName:@"MUSSong" inManagedObjectContext:context];
        song.artistName = artist;
        song.songName = trackName;
        song.genre = genre;
        song.albumTitle = albumTitle;
        return song;
}


@end
