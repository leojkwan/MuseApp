//
//  MUSBlurOverlayViewController.m
//  Muse
//
//  Created by Leo Kwan on 11/23/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSBlurOverlayViewController.h"

@interface MUSBlurOverlayViewController ()
@end

@implementation MUSBlurOverlayViewController

-(instancetype)initWithView:(UIView *)viewOverBlur {
    self = [super init];
    
    if (self) {
        _viewOverBlur = viewOverBlur;
        _blurType = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    // Create Bluw Effect View Over Full Screen
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:self.blurType];
    
    visualEffectView.frame = self.view.bounds;
    
    // Add over main view
    [self.view addSubview:visualEffectView];
    
    // add content over blur
    [visualEffectView addSubview:self.viewOverBlur];
    self.viewOverBlur.frame = visualEffectView.bounds;

}


#pragma Blur Delegate Methods

-(void)didSelectDoneButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
