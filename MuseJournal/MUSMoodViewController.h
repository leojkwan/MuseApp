//
//  MUSMoodViewController.h
//  Muse
//
//  Created by Leo Kwan on 10/13/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"
#import "MUSKeyboardTopBar.h"

@protocol UpdateMoodProtocol <NSObject>
-(void)updateMoodLabelWithText:(NSString *)moodText;
@end

@interface MUSMoodViewController : UIViewController

@property (strong, nonatomic) Entry *destinationEntry;
@property (nonatomic, strong) MUSKeyboardTopBar *destinationToolBar;
@property (nonatomic, assign) id <UpdateMoodProtocol> delegate;

@end
