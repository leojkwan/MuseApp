//
//  Entry.m
//  
//
//  Created by Leo Kwan on 8/28/15.
//
//

#import "Entry.h"
#import "Song.h"


@implementation Entry

@dynamic content;
@dynamic coverImage;
@dynamic createdAt;
@dynamic titleOfEntry;
@dynamic dateInString;
@dynamic songs;

-(NSString *)getTitleOfContent {
    NSString *titleString = [[self.content componentsSeparatedByString:@"\n"] objectAtIndex:0];
    return titleString;
}

@end
