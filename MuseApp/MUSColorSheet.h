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

@property (strong, nonatomic) UIColor *segmentBar;


// text




// color light background
@property (strong, nonatomic) UIColor *searchBarBackground;
@property (strong, nonatomic) UIColor *closeButton;
@property (strong, nonatomic) UIColor *artistLabel;



// color light background
@property (strong, nonatomic) UIColor *segmentNavBackground;



// color dom
@property (strong, nonatomic) UIColor *addEntryHome;

//system colors
@property (strong, nonatomic) UIColor *systemColors;

// entry tool icons
@property (strong, nonatomic) UIColor *toolbarIconTint;


@property (strong, nonatomic) UIColor *iconTint;
//@property (strong, nonatomic) UIColor *segmentBackground;
//@property (strong, nonatomic) UIColor *segmentBackground;



@end
