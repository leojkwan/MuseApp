//
//  MUSAllEntriesTableViewDataSource.m
//  MuseApp
//
//  Created by Leo Kwan on 8/23/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "MUSAllEntriesTableViewDataSource.h"
#import "MUSDataStore.h"
#import "Entry.h"
#import "MUSAllEntriesViewController.h"


@interface MUSAllEntriesViewController ()
@property (nonatomic, strong) MUSDataStore *dataStore;
//@property (nonatomic, strong) NSArray *entries;
@end

@implementation MUSAllEntriesTableViewDataSource

-(instancetype)initWithEntries:(NSArray *)entries {
    self = [super init];

    if (self) {
        _entries = entries;
    }
    return self;
}



@end
