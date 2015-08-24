//
//  UIBarButtonItem+MUSExtraMethods.m
//  MuseApp
//
//  Created by Leo Kwan on 8/24/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "UIBarButtonItem+MUSExtraMethods.h"

@implementation UIBarButtonItem (MUSExtraMethods)

+(UIBarButtonItem *) createPinSongBarButtonItem {

    CGRect barButtonFrame = CGRectMake(0, 0, 30, 30);
    UIButton *pinSongButton = [[UIButton alloc] initWithFrame:barButtonFrame];
    [pinSongButton setBackgroundImage:[UIImage imageNamed:@"pin"] forState:UIControlStateNormal];
    UIBarButtonItem *pinSongBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:pinSongButton];
    return pinSongBarButtonItem;
}

+(UIBarButtonItem *)createPlaylistButton {
    
    CGRect barButtonFrame = CGRectMake(0, 0, 30, 20);
    UIButton *seePlaylistButton = [[UIButton alloc] initWithFrame:barButtonFrame];
    [seePlaylistButton setBackgroundImage:[UIImage imageNamed:@"cassette"] forState:UIControlStateNormal];
    UIBarButtonItem *seePlaylistBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:seePlaylistButton];
    return seePlaylistBarButtonItem;
}


@end
