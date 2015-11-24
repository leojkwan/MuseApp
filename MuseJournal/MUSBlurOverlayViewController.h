//
//  MUSBlurOverlayViewController.h
//  Muse
//
//  Created by Leo Kwan on 11/23/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntryWalkthroughView.h"

@interface MUSBlurOverlayViewController : UIViewController <WalkthroughDelegate> {
    UIModalTransitionStyle modalTransitionStyle;
    UIModalPresentationStyle modalPresentationStyle;
}

// This is the content view over blur
@property (nonatomic, strong) UIView *viewOverBlur;
@property (nonatomic, strong) UIVisualEffect *blurType;
-(void)didSelectDoneButton;
-(instancetype)initWithView:(UIView *)viewOverBlur;

@end
