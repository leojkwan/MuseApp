//
//  MUSImagelessEntryCell.m
//  MuseApp
//
//  Created by Leo Kwan on 9/21/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.


#import "MUSImagelessEntryCell.h"
#import "MUSEntryTableViewCell.h"
#import "NSSet+MUSExtraMethod.h"
#import "NSDate+ExtraMethods.h"
#import "Song.h"
#import "NSAttributedString+MUSExtraMethods.h"
#import "UIFont+MUSFonts.h"
#import "MUSTimeFetcher.h"
#import "UIColor+MUSColors.h"
#import "MUSTagManager.h"


@interface MUSImagelessEntryCell ()

@property (weak, nonatomic) IBOutlet UIView *darkMask;
@property (weak, nonatomic) IBOutlet UILabel *entryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistsLabel;
@property (weak, nonatomic) IBOutlet UILabel *datePinnedLabel;
@property (weak, nonatomic) IBOutlet UILabel *moodLabel;


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
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
        // Setting the background color of the cell.
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    // Configuring the views and colors.
    self.deleteView = [self viewWithImageName:@"trash"];

    
    // Setting the default inactive state color to the tableView background color.
    [cell setDefaultColor:[UIColor MUSBigStone]];
    cell.firstTrigger = 0.50;
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(0, 0, 200, 200)];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}



-(void)configureArtistLabelLogicCell:(MUSImagelessEntryCell *)cell entry:(Entry *)entryForThisRow {

    cell.entryTitleLabel.attributedText =  [NSAttributedString returnMarkDownStringFromString:entryForThisRow.titleOfEntry];
    cell.entryTitleLabel.text = [self.entryTitleLabel.text capitalizedString];
    cell.datePinnedLabel.text = [entryForThisRow.createdAt returnEntryDateStringForDate:entryForThisRow.epochTime];
    
    // FONT
    cell.entryTitleLabel.font = [UIFont returnEntryTitleFont];
    cell.artistsLabel.textColor = [UIColor MUSCorn];
    [cell.artistsLabel setFont:[UIFont fontWithName:@"Raleway-Light" size:11.0]];
    
    // DARK MASK
    cell.darkMask.layer.cornerRadius = 3;
    
//    MOOD LABEL
    NSMutableAttributedString *tag =  [[MUSTagManager returnAttributedStringForTag: entryForThisRow.tag] mutableCopy];
    [tag addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [tag length])];
    self.moodLabel.attributedText = tag;

    
    // PLAYLIST
    NSMutableArray *songsOrderedByDatePinned = [NSSet convertPlaylistArrayFromSet:entryForThisRow.songs];
    cell.artistsLabel.textColor = [UIColor MUSCorn];
    
    // ARTIST LABEL LOGIC
    if (songsOrderedByDatePinned.count == 0) {
        cell.artistsLabel.text = @"";
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

