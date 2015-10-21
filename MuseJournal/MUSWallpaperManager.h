//
//  MUSWallpaperManager.h
//  Muse
//
//  Created by Leo Kwan on 10/14/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MUSWallpaperManager : NSObject

+(NSArray *)returnArrayForWallPaperImages;
+(UIColor *)returnTextColorForWallpaperIndex:(NSInteger)index;
+(NSString *)returnProductIDForWallPaperNamed:(NSString *)name;
+(NSArray *)returnWallpaperArrayWithProductID;
@end
