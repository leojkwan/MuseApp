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


@end

@implementation MUSHomeViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.dateLabel.text = [[NSDate date] returnDayMonthDateFromDate];
    
}

@end
