//
//  MUSAllEntriesTableViewDataSource.h
//  MuseApp
//
//  Created by Leo Kwan on 8/23/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MUSAllEntriesTableViewDataSource : NSObject <UITableViewDataSource>

-(instancetype)initWithEntries:(NSArray *)entries;
@property (nonatomic, strong) NSArray *entries;


@end
