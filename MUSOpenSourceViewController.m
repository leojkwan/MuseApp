//
//  MUSOpenSourceViewController.m
//  Muse
//
//  Created by Leo Kwan on 10/15/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSOpenSourceViewController.h"

@interface MUSOpenSourceViewController ()

@end

@implementation MUSOpenSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
}

- (IBAction)githubLinkTapped:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)githubButtonLinkPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/leojkwan/MuseApp"]];
}


@end
