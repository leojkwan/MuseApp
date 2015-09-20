//
//  MUSAlertViewController.h
//  MuseApp
//
//  Created by Leo Kwan on 9/19/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Song.h"
#import <SCLAlertView.h>


@interface MUSAlertViewController : NSObject

-(instancetype)initDeleteAlertForController:(NSFetchedResultsController *)controller indexPath:(NSIndexPath *)indexPath;

@property (strong ,nonatomic) SCLAlertView *deleteAlertView;


@end
