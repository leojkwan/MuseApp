//
//  Song.h
//  
//
//  Created by Leo Kwan on 8/28/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entry;

@interface Song : NSManagedObject

@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSDate * pinnedAt;
@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) Entry *entry;

@end
