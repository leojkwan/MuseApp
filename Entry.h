//
//  Entry.h
//  MuseApp
//
//  Created by Leo Kwan on 8/23/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Song;

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * coverImage;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * titleOfEntry;
@property (nonatomic, retain) NSSet *songs;
@end

@interface Entry (CoreDataGeneratedAccessors)

- (void)addSongsObject:(Song *)value;
- (void)removeSongsObject:(Song *)value;
- (void)addSongs:(NSSet *)values;
- (void)removeSongs:(NSSet *)values;

@end
