//
//  MUSPlaylistViewController.m
//  
//
//  Created by Leo Kwan on 8/24/15.
//
//

#import "MUSPlaylistViewController.h"

@implementation MUSPlaylistViewController


- (IBAction)exitButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"leaving~~~");
    }];
}

@end
