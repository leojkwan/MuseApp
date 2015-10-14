//
//  MUSTagManager.h
//  Muse
//
//  Created by Leo Kwan on 10/14/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUSTagManager : NSObject

+(NSAttributedString *)returnAttributedStringForTag:(NSString*)mood;
+(NSArray *)returnArrayForTagImages;

@end
