//
//  MUSEntryTableViewCell.m
//  MuseApp
//
//  Created by Leo Kwan on 8/23/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "MUSEntryTableViewCell.h"
#import "NSSet+MUSExtraMethod.h"
#import "Song.h"
#import "MUSAlertView.h"
#import "NSDate+ExtraMethods.h"
#import "NSAttributedString+MUSExtraMethods.h"
#import "MUSTimeFetcher.h"
#import "UIFont+MUSFonts.h"
#import "UIColor+MUSColors.h"
#import <Masonry/Masonry.h>
#import "MUSTagManager.h"
#import "NSAttributedString+MUSExtraMethods.h"

@interface MUSEntryTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *darkMask;

@property (weak, nonatomic) IBOutlet UIImageView *entryImageView;
@property (weak, nonatomic) IBOutlet UILabel *entryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistsLabel;
@property (weak, nonatomic) IBOutlet UILabel *datePinnedLabel;
@property (weak, nonatomic) IBOutlet UILabel *moodLabel;

@end

@implementation MUSEntryTableViewCell

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
        cell.contentView.backgroundColor = [UIColor darkGrayColor];
    }
    
    // Configuring the views and colors.
    self.deleteView = [self viewWithImageName:@"delete"];
    
    // Setting the default inactive state color to the tableView background color.
    [cell setDefaultColor:[UIColor darkGrayColor]];
    cell.firstTrigger = 0.50;
}


- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(0, 0, 200, 200)];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

-(void)setUpViewsForCell:(MUSEntryTableViewCell *)cell entry:(Entry *)entryForThisRow {
    
    // set views
    cell.entryTitleLabel.attributedText =  [NSAttributedString returnMarkDownStringFromString:entryForThisRow.titleOfEntry];
    cell.entryTitleLabel.text = [self.entryTitleLabel.text capitalizedString];
    
    
//     SET UP MOOD LABEL
    
    NSMutableAttributedString *tag =  [[MUSTagManager returnAttributedStringForTag: entryForThisRow.tag] mutableCopy];
    [tag addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [tag length])];
    self.moodLabel.attributedText = tag;


    // set up font
    cell.entryTitleLabel.font = [UIFont returnEntryTitleFont];
    cell.artistsLabel.textColor = [UIColor MUSCorn];
    
    // DATE
    cell.datePinnedLabel.text = [entryForThisRow.createdAt returnEntryDateStringForDate:entryForThisRow.epochTime];
    
    
    

    cell.entryImageView.image = [UIImage imageWithData:entryForThisRow.coverImage];


    cell.darkMask.layer.cornerRadius = 3;

}


-(void)configureArtistLabelLogicCell:(MUSEntryTableViewCell *)cell entry:(Entry *)entryForThisRow {
    
    
    // SET UP UI
    [self setUpViewsForCell:cell entry:entryForThisRow];
    
    // playlist text
    NSMutableArray *songsOrderedByDatePinned = [NSSet convertPlaylistArrayFromSet:entryForThisRow.songs];
    
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
