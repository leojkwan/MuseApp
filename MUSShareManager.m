//
//  MUSShareManager.m
//  Muse
//
//  Created by Leo Kwan on 10/15/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSShareManager.h"


@implementation MUSShareManager

+(UIActivityViewController *)returnShareSheetWithEntry:(Entry *)entry {
    
    //SHARE IMAGE IF THERE IS ONE
    UIImage *entryImage = [[UIImage alloc] init];
    if (entry.coverImage != nil) {
        entryImage = [UIImage imageWithData:entry.coverImage];
    }
    
    //SHARE CONTENT IF THERE IS
    
    NSString *entryTitle = entry.titleOfEntry;
    NSString *entryBody = entry.content;
    
    if (entryTitle == nil)
        entryTitle = @"";
    if (entryBody == nil) {
        entryBody = @"";
    }
    
    
    NSString *completeEntry = [NSString stringWithFormat:@"%@ \n \n %@", entryTitle, entryBody];
    
    NSArray *postItems = @[entryImage, completeEntry];
    UIActivityViewController *shareSheet = [[UIActivityViewController alloc]
                                            initWithActivityItems:postItems
                                            applicationActivities:nil];
    return shareSheet;
}

@end
