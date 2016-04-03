//
//  MUSOpenSourceViewController.m
//  Muse

#import "MUSOpenSourceViewController.h"

@interface MUSOpenSourceViewController ()

@end

@implementation MUSOpenSourceViewController

- (IBAction)githubLinkTapped:(id)sender {
}

- (IBAction)githubButtonLinkPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/leojkwan/MuseApp"]];
}


@end
