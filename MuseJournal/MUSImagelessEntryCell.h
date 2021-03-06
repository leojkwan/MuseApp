//
//  MUSImagelessEntryCell.h
//  MuseApp
//
//  Created by Leo Kwan on 9/21/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <MCSwipeTableViewCell.h>
#import "Entry.h"

@interface MUSImagelessEntryCell : MCSwipeTableViewCell<MCSwipeTableViewCellDelegate>

@property (nonatomic, strong) UIView *deleteView;
-(void)setUpSwipeOptionsForCell:(MUSImagelessEntryCell *)cell;
-(void)configureArtistLabelLogicCell:(MUSImagelessEntryCell *)cell entry:(Entry *)entryForThisRow;

@end
