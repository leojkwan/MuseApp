//
//  MUSSongTableViewCell.m
//  MuseApp
//
//  Created by Leo Kwan on 8/28/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "MUSSongTableViewCell.h"

@implementation MUSSongTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    NSArray *imageNames = @[@"icon1", @"icon2", @"icon3", @"icon4", @"icon5"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    
    // set image array to my animation property
    self.animatingIcon.animationImages = images;
    self.animatingIcon.animationDuration = 1.2;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
