//
//  MUSEntryTableViewCell.h
//  MuseApp
//
//  Created by Leo Kwan on 8/23/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MCSwipeTableViewCell.h>
#import "Entry.h"

@interface MUSEntryTableViewCell : MCSwipeTableViewCell<MCSwipeTableViewCellDelegate>

@property (nonatomic, strong) UIView *deleteView;


-(void)setUpSwipeOptionsForCell:(MUSEntryTableViewCell *)cell;
-(void)configureArtistLabelLogicCell:(MUSEntryTableViewCell *)cell entry:(Entry *)entryForThisRow;


@end
