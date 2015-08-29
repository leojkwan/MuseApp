//
//  MUSEntryTableViewCell.m
//  MuseApp
//
//  Created by Leo Kwan on 8/23/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "MUSEntryTableViewCell.h"


@implementation MUSEntryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}
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

@end
