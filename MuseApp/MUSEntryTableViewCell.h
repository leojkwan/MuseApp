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

@property (weak, nonatomic) IBOutlet UIImageView *entryImageView;
@property (weak, nonatomic) IBOutlet UILabel *entryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistsLabel;
@property (weak, nonatomic) IBOutlet UILabel *datePinnedLabel;
@property (nonatomic, strong) UIView *deleteView;

-(void)setUpSwipeOptionsForCell:(MUSEntryTableViewCell *)cell;
-(void)configureArtistLabelLogicCell:(MUSEntryTableViewCell *)cell entry:(Entry *)entryForThisRow;


@end
