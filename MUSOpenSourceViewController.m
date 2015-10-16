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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)githubButtonLinkPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/leojkwan/MuseApp"]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
