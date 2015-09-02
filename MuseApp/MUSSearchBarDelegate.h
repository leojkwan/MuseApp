//
//  MUSSearchBarDelegate.h
//  
//
//  Created by Leo Kwan on 9/2/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Entry.h"
#import "Song.h"

@interface MUSSearchBarDelegate : NSObject<UISearchBarDelegate>

-(instancetype)initWithTableView:(UITableView *)tableView resultsController:(NSFetchedResultsController *)controller;


@end
