//
//  MUSWallpaperCollectionViewCell.m
//  Muse
//
//  Created by Leo Kwan on 10/14/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSWallpaperCollectionViewCell.h"

@implementation MUSWallpaperCollectionViewCell

-(void)awakeFromNib {
self.layer.borderColor = [UIColor whiteColor].CGColor;
 self.layer.cornerRadius = 5;
self.layer.borderWidth = 2.0f;
self.selected = YES; // why
}

@end
