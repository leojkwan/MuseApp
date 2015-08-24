//
//  Entry.m
//  MuseApp
//
//  Created by Leo Kwan on 8/23/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "Entry.h"
#import "Song.h"


@implementation Entry

@dynamic content;
@dynamic coverImage;
@dynamic createdAt;
@dynamic titleOfEntry;
@dynamic songs;

-(NSString *)getTitleOfContent {
    NSString *titleString = [[self.content componentsSeparatedByString:@"\n"] objectAtIndex:0];
    return titleString;
}

@end
