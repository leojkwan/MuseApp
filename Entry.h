//
//  Entry.h
//  
//
//  Created by Leo Kwan on 8/28/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Song;

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSData * coverImage;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * titleOfEntry;
@property (nonatomic, retain) NSString * dateInString;
@property (nonatomic, retain) NSSet *songs;
@end

@interface Entry (CoreDataGeneratedAccessors)

- (void)addSongsObject:(Song *)value;
- (void)removeSongsObject:(Song *)value;
- (void)addSongs:(NSSet *)values;
- (void)removeSongs:(NSSet *)values;

@end
