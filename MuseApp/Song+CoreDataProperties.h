//
//  Song+CoreDataProperties.h
//  
//
//  Created by Leo Kwan on 9/20/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@interface Song (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *artistName;
@property (nullable, nonatomic, retain) NSString *genre;
@property (nullable, nonatomic, retain) NSDate *pinnedAt;
@property (nullable, nonatomic, retain) NSString *songName;
@property (nullable, nonatomic, retain) NSNumber *persistentID;
@property (nullable, nonatomic, retain) Entry *entry;

@end

NS_ASSUME_NONNULL_END
