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
@property (nonatomic, strong) NSArray *entries;


+ (instancetype)sharedDataStore;

- (void)save;
- (void )fetchEntries;
- (NSURL *)applicationDocumentsDirectory;


@end
