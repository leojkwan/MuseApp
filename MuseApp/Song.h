//
//  Song.h
//  
//
//  Created by Leo Kwan on 9/21/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entry;

NS_ASSUME_NONNULL_BEGIN

@interface Song : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

-(instancetype)initWithTitle:(NSString *)title artist:(NSString*)artist genre:(NSString *)genre album:(NSString *)genre;

@end

NS_ASSUME_NONNULL_END

#import "Song+CoreDataProperties.h"
