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
        NSArray *playlistArrayForThisEntry = [[set allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinnedAt" ascending:YES]]];
    
    return [playlistArrayForThisEntry mutableCopy];
}


@end
