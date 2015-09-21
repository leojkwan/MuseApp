//
//  MUSImagelessEntryCell.m
//  MuseApp
//
//  Created by Leo Kwan on 9/21/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSImagelessEntryCell.h"
#import "MUSEntryTableViewCell.h"
#import "NSSet+MUSExtraMethod.h"
#import "Song.h"
#import "NSAttributedString+MUSExtraMethods.h"

@interface MUSImagelessEntryCell ()
@property (nonatomic, strong) UIView *deleteView;

@end

@implementation MUSImagelessEntryCell


- (void)awakeFromNib {
    
} 

// MCSwipable Cell
-(void)setUpSwipeOptionsForCell:(MUSEntryTableViewCell *)cell {
    
    if (!cell) {
        cell = [[MUSEntryTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"entryCell"];
        
        // Remove inset of iOS 7 separators.
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        // Setting the background color of the cell.
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    // Setting the default inactive state color to the tableView background color.
    [cell setDefaultColor:[UIColor darkGrayColor]];
    cell.firstTrigger = 0.50;
}



-(void)configureArtistLabelLogicCell:(MUSEntryTableViewCell *)cell entry:(Entry *)entryForThisRow {
    
    cell.entryTitleLabel.attributedText =  [NSAttributedString returnMarkDownStringFromString:entryForThisRow.titleOfEntry];
    
    
    // playlist text
    NSMutableArray *songsOrderedByDatePinned = [NSSet convertPlaylistArrayFromSet:entryForThisRow.songs];
    
    // ARTIST LABEL LOGIC

    if (songsOrderedByDatePinned.count == 0) {
        cell.artistsLabel.text = @"—";
    }
    else if (songsOrderedByDatePinned.count == 1 ) {
        Song *firstSongForThisRow = songsOrderedByDatePinned[0];
        NSString *oneArtist = [NSString stringWithFormat:@"%@" ,firstSongForThisRow.artistName];
        cell.artistsLabel.text = oneArtist;
    }
    else if (songsOrderedByDatePinned.count > 1) {
        Song *firstSongForThisRow = songsOrderedByDatePinned[0];
        NSString *moreThanOneArtist = [NSString stringWithFormat:@"%@ and more", firstSongForThisRow.artistName];
        cell.artistsLabel.text = moreThanOneArtist;
    }
    
    
}


@end

