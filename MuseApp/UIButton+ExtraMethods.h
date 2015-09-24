//
//  UIButton+ExtraMethods.h
//  MuseApp
//
//  Created by Leo Kwan on 8/24/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ExtraMethods)

+(UIButton *)createPinSongButton;
+(UIButton *)createPlaylistButton;
+(UIButton *)createCameraButton;
+(UIButton*)createShuffleButtonWithFrame:(CGRect)frame tintColor:(UIColor *)color;


@end
