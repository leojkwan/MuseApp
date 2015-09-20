//
//  MUSAlertViewController.m
//  MuseApp
//
//  Created by Leo Kwan on 9/19/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSAlertViewController.h"
#import "MUSDataStore.h"
#import <SCLAlertView.h>


@interface MUSAlertViewController ()
@property (nonatomic, strong) MUSDataStore *store;

@end

@implementation MUSAlertViewController


-(instancetype)initDeleteAlertForController:(NSFetchedResultsController *)controller indexPath:(NSIndexPath *)indexPath {
    self = [super init];
    if (self) {
        // alert user
        
        _deleteAlertView = [[SCLAlertView alloc] init];
        
        _deleteAlertView.shouldDismissOnTapOutside = YES;
        _deleteAlertView.showAnimationType = FadeIn;
        
        [_deleteAlertView addButton:@"Delete" actionBlock:^(void) {
            MUSDataStore *store = [MUSDataStore sharedDataStore];
            NSManagedObject *managedObject = [controller objectAtIndexPath:indexPath];
            [store.managedObjectContext deleteObject:managedObject];
            [store.managedObjectContext save:nil];
        }];
    }
    
    return self;
}





@end
