//
//  MUSShareManager.h
//  Muse
//
//  Created by Leo Kwan on 10/15/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Entry.h"

@interface MUSShareManager : NSObject

+(UIActivityViewController *)returnShareSheetWithEntry:(Entry *)entry;

@end
