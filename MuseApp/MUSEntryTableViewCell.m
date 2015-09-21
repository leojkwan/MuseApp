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
#import "NSAttributedString+MUSExtraMethods.h"


@implementation MUSEntryTableViewCell

- (void)awakeFromNib {
    

 
}

// prevents cell image from fluttering on selected and scroll
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor *color = self.blurView.backgroundColor;
    [super setSelected:selected animated:animated];
    
    if (selected){
        self.blurView.backgroundColor = color;
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    UIColor *color = self.blurView.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted){
        self.blurView.backgroundColor = color;
    }
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


-(void)configureArtistLabelLogicCell:(MUSEntryTableViewCell *)cell entry:(Entry *)entryForThisRow {
    
    // set views
    cell.entryImageView.image = [UIImage imageWithData:entryForThisRow.coverImage];
    cell.entryTitleLabel.attributedText =  [NSAttributedString returnMarkDownStringFromString:entryForThisRow.titleOfEntry];
    cell.entryTitleLabel.text = [self.entryTitleLabel.text capitalizedString];


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
