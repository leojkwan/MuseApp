//
//  MUSDataStore.h
//  MuseApp
//
//  Created by Leo Kwan on 8/23/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MUSDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedDataStore;

- (void)save;
- (NSArray *)fetchEntries;
- (NSURL *)applicationDocumentsDirectory;


@end
