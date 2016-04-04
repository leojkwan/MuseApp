//
//  EntryWalkthroughView.m
//  Muse
//
//  Created by Leo Kwan on 11/22/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "EntryWalkthroughView.h"
#import <Masonry/Masonry.h>
#import "UIColor+MUSColors.h"
#import "UIFont+MUSFonts.h"

#define VIEW_WIDTH [[UIScreen mainScreen] bounds].size.width

@implementation EntryWalkthroughView

-(instancetype)init {
    self = [super init];
    
    if (self) {
        
        // Add Music to Playlist
        UILabel *titleLabel = [self returnTitleLabelWithText:@"Adding Songs to your Entry"];
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            // Needs to be 12 (not 10 like ui label) because icon has padding
            make.top.equalTo(self).with.offset(VIEW_WIDTH/12);
            make.centerX.equalTo(self);
            make.width.equalTo(self).multipliedBy(.9);
        }];

    
        // SEARCH ICON
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchSong"]];
        searchIcon.tintColor = [UIColor MUSCorn];
        [self addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            
            // Needs to be 12 (not 10 like ui label) because icon has padding
            make.top.equalTo(titleLabel.mas_bottom).with.offset(VIEW_WIDTH/8);
            make.left.equalTo(self).with.offset(VIEW_WIDTH/12);
            make.width.equalTo(self).dividedBy(5);
            make.height.equalTo(searchIcon.mas_width);
        }];
        
        //SEARCH TEXT
        
         UILabel *searchLabel = [self returnMessageLabelWithText:@"1. Find a song in your iTunes music library"];
        [self addSubview:searchLabel];

        [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(searchIcon);
            make.left.equalTo(searchIcon.mas_right);
            make.right.equalTo(self.mas_right).with.offset(-VIEW_WIDTH/10);
        }];
        
    
        // PIN ICON
        UIImageView *pinIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinSong"]];
        pinIcon.tintColor = [UIColor MUSCorn];
        [self addSubview:pinIcon];
        [pinIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(searchLabel.mas_right);
            make.top.equalTo(searchIcon.mas_bottom).with.offset(VIEW_WIDTH/10);
            make.width.equalTo(self).dividedBy(5);
            make.height.equalTo(searchIcon.mas_width);
        }];
        
        
        //PIN TEXT
        
        UILabel *pinLabel = [self returnMessageLabelWithText:@"2. Pin the song to your entry!"];
        [self addSubview:pinLabel];
        [pinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(searchIcon.mas_left);
            make.centerY.equalTo(pinIcon);
            make.right.equalTo(pinIcon.mas_left);
        }];
        
        
        // MUSIC ICON
        UIImageView *musicPlayerIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"musicPlayer"]];
        musicPlayerIcon.tintColor = [UIColor MUSCorn];
        [self addSubview:musicPlayerIcon];
        [musicPlayerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(pinLabel.mas_left);
            make.top.equalTo(pinLabel.mas_bottom).with.offset(VIEW_WIDTH/8);
            make.width.equalTo(self).dividedBy(5);
            make.height.equalTo(searchIcon.mas_width);
        }];
        
        //MUSIC TEXT
    
        UILabel *musicPlayerLabel = [self returnMessageLabelWithText:@"3. See your playlist and music player!"];
        [self addSubview:musicPlayerLabel];
        
        [musicPlayerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(musicPlayerIcon);
            make.left.equalTo(searchIcon.mas_right);
            make.right.equalTo(pinIcon.mas_right);
        }];
        
        // Done Button
        UIButton *doneButton = [[UIButton alloc] init];
        [doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setBackgroundColor:[UIColor colorWithRed:0.29 green:0.74 blue:0.32 alpha:1]];
        doneButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:24];
        doneButton.titleLabel.textColor = [UIColor whiteColor];
        [doneButton setTitle:@"Got it!" forState:UIControlStateNormal];
        doneButton.layer.cornerRadius = 20;
        
        [self addSubview:doneButton];
        
        [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).with.offset(-VIEW_WIDTH/10);
            make.width.equalTo(self).dividedBy(2);
            make.centerX.equalTo(self);
        }];
        
        [self bringSubviewToFront:doneButton];
 
    }
    
    return self;
}

-(UILabel *)returnMessageLabelWithText:(NSString *)message {
    UILabel *label = [[UILabel alloc] init];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Avenir" size:20];
    
    // minimum font size
    label.minimumScaleFactor = 15/[UIFont labelFontSize];
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 2;
    return label;
}

-(UILabel *)returnTitleLabelWithText:(NSString *)message {
    UILabel *label = [[UILabel alloc] init];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"SemplicitaPro-Medium" size:20.0];
    
    // minimum font size
    label.minimumScaleFactor = 15/[UIFont labelFontSize];
    label.adjustsFontSizeToFitWidth = YES;
    label.numberOfLines = 1;
    return label;
}


-(void)doneButtonTapped:(id)sender {
    [self.delegate dismissView];
}

@end
