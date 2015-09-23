//
//  UIButton+ExtraMethods.m
//  MuseApp
//
//  Created by Leo Kwan on 8/24/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "UIButton+ExtraMethods.h"

@implementation UIButton (ExtraMethods)

+(UIButton *) createPinSongButton {

    CGRect barButtonFrame = CGRectMake(0, 0, 30, 30);
    UIButton *pinSongButton = [[UIButton alloc] initWithFrame:barButtonFrame];
    [pinSongButton setBackgroundImage:[UIImage imageNamed:@"pin"] forState:UIControlStateNormal];
    return pinSongButton;
}

+(UIButton*)createPlaylistButton {
    
    CGRect barButtonFrame = CGRectMake(0, 0, 30, 20);
    UIButton *seePlaylistButton = [[UIButton alloc] initWithFrame:barButtonFrame];
    [seePlaylistButton setBackgroundImage:[UIImage imageNamed:@"cassette"] forState:UIControlStateNormal];
    return seePlaylistButton;
}

+(UIButton*)createCameraButton {
    CGRect barButtonFrame = CGRectMake(0, 0, 30, 25);
    UIButton *seePlaylistButton = [[UIButton alloc] initWithFrame:barButtonFrame];
    [seePlaylistButton setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    return seePlaylistButton;
}



@end
