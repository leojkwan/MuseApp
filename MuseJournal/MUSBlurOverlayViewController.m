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
    //     Create Blur Effect View Over Full Screen
    UIView *darkOverlay = [[UIView alloc] init];
    darkOverlay.backgroundColor = [UIColor blackColor];
    darkOverlay.alpha = .85;
    
    //    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:self.blurType];
    //    visualEffectView.frame = self.view.bounds;
    //
    // Add over main view
    //    [self.view addSubview:visualEffectView];
    //
    [self.view addSubview:darkOverlay];
    darkOverlay.frame = self.view.bounds;
    
    
    //     add content over blur
    [darkOverlay addSubview:self.viewOverBlur];
    self.viewOverBlur.frame = darkOverlay.bounds;
    //    [visualEffectView addSubview:self.viewOverBlur];
    //    self.viewOverBlur.frame = visualEffectView.bounds;
    
}

#pragma Blur Delegate Methods

-(void)didSelectDoneButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
