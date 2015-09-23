//
//  MUSHomeViewController.m
//  MuseApp
//
//  Created by Leo Kwan on 9/18/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSHomeViewController.h"
#import "NSDate+ExtraMethods.h"
#import <Masonry.h>

@interface MUSHomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;


@end

@implementation MUSHomeViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    self.dateLabel.text = [[NSDate date] returnDayMonthDateFromDate];
    
    if ( [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"]  != NULL) {
            self.greetingLabel.text = [NSString stringWithFormat:@"Good Morning %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"]];
    }
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"] );
}

-(BOOL)prefersStatusBarHidden {
    [self setNeedsStatusBarAppearanceUpdate];
    return NO;
}

@end
