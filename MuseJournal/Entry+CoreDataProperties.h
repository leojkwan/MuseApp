//
//  Entry+CoreDataProperties.h
//  
//
//  Created by Leo Kwan on 10/1/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Entry.h"

NS_ASSUME_NONNULL_BEGIN

@interface Entry (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSData *coverImage;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *dateInString;
@property (nullable, nonatomic, retain) NSString *tag;
@property (nullable, nonatomic, retain) NSString *titleOfEntry;
@property (nullable, nonatomic, retain) NSDate *epochTime;
@property (nullable, nonatomic, retain) NSSet<Song *> *songs;

@end

@interface Entry (CoreDataGeneratedAccessors)

- (void)addSongsObject:(Song *)value;
- (void)removeSongsObject:(Song *)value;
- (void)addSongs:(NSSet<Song *> *)values;
- (void)removeSongs:(NSSet<Song *> *)values;

@end

NS_ASSUME_NONNULL_END
