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

#define VIEW_WIDTH [[UIScreen mainScreen] bounds].size.width

@implementation EntryWalkthroughView

-(instancetype)init {
    self = [super init];
    
    if (self) {
        
        // SEARCH ICON
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchSong"]];
        searchIcon.tintColor = [UIColor MUSCorn];
        [self addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            
            // Needs to be 12 (not 10 like ui label) because icon has padding
            make.top.and.left.equalTo(self).with.offset(VIEW_WIDTH/12);
            make.width.equalTo(self).dividedBy(5);
            make.height.equalTo(searchIcon.mas_width);
        }];
        
        //SEARCH TEXT
        
         UILabel *searchLabel = [self returnMessageLabelWithText:@"Find a song in your iTunes music library"];
        [self addSubview:searchLabel];

        [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(searchIcon);
            make.left.equalTo(searchIcon.mas_right);
            make.right.equalTo(self.mas_right).with.offset(-VIEW_WIDTH/10);
            NSLog(@"This is the screen width:%f", [[UIScreen mainScreen] bounds].size.width);
        }];
        
    
        // PIN ICON
        UIImageView *pinIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinSong2"]];
        [self addSubview:pinIcon];
        
        [pinIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(searchLabel.mas_right);
            make.top.equalTo(searchIcon.mas_bottom).with.offset(VIEW_WIDTH/10);
            make.width.equalTo(self).dividedBy(5);
            make.height.equalTo(searchIcon.mas_width);
        }];
        
        
        //PIN TEXT
        
        UILabel *pinLabel = [self returnMessageLabelWithText:@"Pin the song to your entry!"];
        [self addSubview:pinLabel];
        
        [pinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(searchIcon.mas_left);
            make.centerY.equalTo(pinIcon);
            make.right.equalTo(pinIcon.mas_left).with.offset(VIEW_WIDTH/12);
        }];
        
        
        // MUSIC ICON
        UIImageView *musicPlayerIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"musicPlayer"]];
        musicPlayerIcon.tintColor = [UIColor MUSRebeccaAlmond];
        [self addSubview:musicPlayerIcon];
        [musicPlayerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(pinLabel.mas_left);
            make.top.equalTo(pinLabel.mas_bottom).with.offset(VIEW_WIDTH/10);
            make.width.equalTo(self).dividedBy(5);
            make.height.equalTo(searchIcon.mas_width);
        }];
        
        //MUSIC TEXT
        
        UILabel *musicPlayerLabel = [self returnMessageLabelWithText:@"See your playlist and music player!"];
        [self addSubview:musicPlayerLabel];
        
        [musicPlayerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(musicPlayerIcon);
            make.left.equalTo(searchIcon.mas_right).with.offset(VIEW_WIDTH/12);
            make.right.equalTo(pinIcon.mas_right);
            NSLog(@"This is the screen width:%f", [[UIScreen mainScreen] bounds].size.width);
        }];
        
        
        
        
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

@end
