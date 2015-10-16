//
//  MUSWallpaperManager.m
//  Muse
//
//  Created by Leo Kwan on 10/14/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSWallpaperManager.h"
#import "UIColor+MUSColors.h"

@implementation MUSWallpaperManager


+(NSArray *)returnArrayForWallPaperImages {
    return  @[
              //  DARK BACKGROUND
              @[@"Dock", [UIImage imageNamed:@"wallpaper1"]],
              @[@"Seagull", [UIImage imageNamed:@"wallpaper2"]],
              @[@"Norway River", [UIImage imageNamed:@"wallpaper3"]],
              @[@"Vintage Camera", [UIImage imageNamed:@"wallpaper4"]],
              @[@"Hammer", [UIImage imageNamed:@"wallpaper5"]],
              
              
              
              
              //  LIGHT BACKGROUND
              @[@"norwayriver", [UIImage imageNamed:@"wallpaper3"]],
              @[@"mountains", [UIImage imageNamed:@"wallpaper1"]],
              @[@"norwaydock", [UIImage imageNamed:@"wallpaper2"]],
              @[@"norwayriver", [UIImage imageNamed:@"wallpaper3"]],
              @[@"mountains", [UIImage imageNamed:@"wallpaper1"]],
              @[@"norwaydock", [UIImage imageNamed:@"wallpaper2"]],
              @[@"norwayriver", [UIImage imageNamed:@"wallpaper3"]],
              @[@"mountains", [UIImage imageNamed:@"wallpaper1"]],
              @[@"norwaydock", [UIImage imageNamed:@"wallpaper2"]],
              @[@"norwayriver", [UIImage imageNamed:@"wallpaper3"]],
              @[@"mountains", [UIImage imageNamed:@"wallpaper1"]],
              @[@"norwaydock", [UIImage imageNamed:@"wallpaper2"]],
              @[@"norwayriver", [UIImage imageNamed:@"wallpaper3"]]
              
              
              //              @[@"Chill", [UIImage imageNamed:@"Chill"]],
              //              @[@"Celebratory", [UIImage imageNamed:@"Celebratory"]],
              //              @[@"Confident", [UIImage imageNamed:@"Confident"]],
              //              @[@"Discouraged", [UIImage imageNamed:@"Discouraged"]],
              //              @[@"Disappointed", [UIImage imageNamed:@"Disappointed"]],
              //              @[@"Excited", [UIImage imageNamed:@"Excited"]],
              //              @[@"Festive", [UIImage imageNamed:@"Festive"]],
              //              @[@"Frustrated", [UIImage imageNamed:@"Frustrated"]],
              //              @[@"Happy", [UIImage imageNamed:@"Happy"]],
              //              @[@"Hyped", [UIImage imageNamed:@"Hyped"]],
              //              @[@"Hustlin", [UIImage imageNamed:@"Hustlin"]],
              //              @[@"Romantic", [UIImage imageNamed:@"Romantic"]],
              //              @[@"Rejected", [UIImage imageNamed:@"Rejected"]],
              //              @[@"Sleepy", [UIImage imageNamed:@"Sleepy"]],
              ];
}

// RETURN UI COLOR BASED ON WALLPAPER CONTRAST

+(UIColor *)returnTextColorForWallpaperIndex:(NSInteger)index {
    if (index >= 0 && index <= 5)
        return [UIColor whiteColor];
    else
        return [UIColor MUSBigStone];
}

@end
