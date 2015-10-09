//
//  LastWalkthroughViewController.m
//  Muse
//
//  Created by Leo Kwan on 10/8/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "LastWalkthroughViewController.h"

@interface LastWalkthroughViewController ()

@end

@implementation LastWalkthroughViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneButtonPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstTimeUser"];
    [self.navigationController popViewControllerAnimated:YES];
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
