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
              
              
              //  LIGHT BACKGROUND
              @[@"Vintage Camera", [UIImage imageNamed:@"wallpaper4"]],
              @[@"Seagull", [UIImage imageNamed:@"wallpaper2"]],
              @[@"Vinyl", [UIImage imageNamed:@"wallpaper14"]],
              
              //  DARK BACKGROUND
              @[@"Venice", [UIImage imageNamed:@"wallpaper6"]],
              @[@"Balloons", [UIImage imageNamed:@"wallpaper10"]],
              @[@"Electric", [UIImage imageNamed:@"wallpaper13"]],

              @[@"Shooting Star", [UIImage imageNamed:@"wallpaper12"]],
              @[@"Coffee Bean", [UIImage imageNamed:@"wallpaper11"]],
              @[@"Calm", [UIImage imageNamed:@"wallpaper1"]],
              @[@"Rose", [UIImage imageNamed:@"wallpaper3"]],
              @[@"Hammer", [UIImage imageNamed:@"wallpaper5"]],
              @[@"Spark", [UIImage imageNamed:@"wallpaper7"]],
              @[@"Tiger", [UIImage imageNamed:@"wallpaper8"]],
              @[@"Jellyfish", [UIImage imageNamed:@"wallpaper9"]],
              ];
}




// RETURN UI COLOR BASED ON WALLPAPER CONTRAST

+(UIColor *)returnTextColorForWallpaperIndex:(NSInteger)index {
    if (index > 2 )
        return [UIColor whiteColor];
    else
        return [UIColor MUSBigStone];
}

@end
