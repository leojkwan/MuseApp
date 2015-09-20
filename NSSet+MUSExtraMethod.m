//
//  NSSet+MUSExtraMethod.m
//  MuseApp
//
//  Created by Leo Kwan on 8/24/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "NSSet+MUSExtraMethod.h"
#import "Song.h"

@implementation NSSet (MUSExtraMethod)

+(NSMutableArray *)convertPlaylistArrayFromSet:(NSSet *)set {
    
        NSMutableArray *playlistArrayForThisEntry = [[set allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinnedAt" ascending:YES]]];
//
//    // Pull artist and song strings from Sorted Songs Array above
//    NSMutableArray *playlistArrayWithSongsInCorrectFormat = [[NSMutableArray alloc] init];
//    
//    for (Song *song in playlistArrayForThisEntry) {
//        NSMutableArray *songArray = [[NSMutableArray alloc] init];
//        [songArray addObject:song.artistName];
//        [songArray addObject:song.songName];
//        [playlistArrayWithSongsInCorrectFormat addObject:songArray];
//    }
//    return playlistArrayWithSongsInCorrectFormat;
    
    return playlistArrayForThisEntry;
    
}


@end
