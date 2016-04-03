//
//  MUSColorSheet.h
//  MuseApp
//
//  Created by Leo Kwan on 9/24/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MUSColorSheet : NSObject

+ (MUSColorSheet *)sharedInstance;

// color light background

@property (strong, nonatomic) UIColor *artistLabel;
@property (strong, nonatomic) UIColor *segmentBar;

// color light background
@property (strong, nonatomic) UIColor *segmentNavBackground;
@property (strong, nonatomic) UIColor *searchBarBackground;
@property (strong, nonatomic) UIColor *musicPlayerStyle;

// color dark
@property (strong, nonatomic) UIColor *toolbarIcon;
@property (strong, nonatomic) UIColor *musicPlayIcon;
@property (strong, nonatomic) UIColor *backButtonText;
@property (strong, nonatomic) UIColor *nowPlayingText;

// color dark2
@property (strong, nonatomic) UIColor *sectionText;
@property (strong, nonatomic) UIColor *sectionbackGround;

//system colors
@property (strong, nonatomic) UIColor *systemColors;

// entry tool icons
@property (strong, nonatomic) UIColor *keyboardIconTint;
@property (strong, nonatomic) UIColor *keyboardBackground;
@property (strong, nonatomic) UIColor *toolbarBackGround;
@property (strong, nonatomic) UIColor *iconTint;



// text editor
@property (strong, nonatomic) UIColor *headerColor;
@property (strong, nonatomic) UIColor *textColor;




@end
