//
//  MUSSongTableViewCell.h
//  MuseApp
//
//  Created by Leo Kwan on 8/28/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSIconAnimation.h"

@interface MUSSongTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *songArtworkImageView;
@property (weak, nonatomic) IBOutlet UILabel *songNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *animatingIcon;

@end
