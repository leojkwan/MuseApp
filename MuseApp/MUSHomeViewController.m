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
#import "MUSTimeFetcher.h"


@interface MUSHomeViewController ()<CurrentTimeDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,assign) TimeOfDay time;
@property (weak, nonatomic) IBOutlet UIButton *mood1icon;
@property (weak, nonatomic) IBOutlet UIButton *mood2icon;
@property (weak, nonatomic) IBOutlet UIButton *mood3icon;
@property (weak, nonatomic) IBOutlet UIButton *mood4icon;
@property (strong, nonatomic) MUSTimeFetcher* timeManager;


@end

@implementation MUSHomeViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.timeManager = [[MUSTimeFetcher alloc] init];
    
    self.timeManager.delegate = self;
    self.time = self.timeManager.timeOfDay;
    self.dateLabel.text = [[NSDate date] returnDayMonthDateFromDate];
    [self presentGreeting];
    

}

-(void)updatedTime:(NSString *)timeString {
    self.timeLabel.text = timeString;
}

-(void)presentGreeting {
//    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//    if (screenBounds.size.height < 569) {
//        // iphone 5s less]
//        self.greetingLabel.font = [UIFont fontWithName:@"Futura-Medium" size:23];
//        self.dateLabel.font = [UIFont fontWithName:@"GillSans-Light" size:17];
//    } else {
//        // iphone 6 and up
//        self.greetingLabel.font = [UIFont fontWithName:@"Futura-Medium" size:30];
//        self.dateLabel.font = [UIFont fontWithName:@"GillSans-Light" size:23];
//    }
//    
    
    if ( [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"]  != NULL) {
        // IF THERE IS A USERNAME
        switch (self.time) {
            case Morning:
                self.greetingLabel.text = [NSString stringWithFormat:@"Good Morning %@!", [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"]];
                break;
            case Afternoon:
                self.greetingLabel.text = [NSString stringWithFormat:@"Good Afternoon %@.", [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"]];
                break;
            default:
                self.greetingLabel.text = [NSString stringWithFormat:@"Good Evening %@.", [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"]];
                break;
                

                
        }
        
        
        // ELSE
    } else {
        switch (self.time) {
            case Morning:
                self.greetingLabel.text = @"Good Morning.";
                break;
            case Afternoon:
                self.greetingLabel.text = @"Good Afternoon.";
            default:
                self.greetingLabel.text = @"Good Evening.";
                break;
        }
    }
}


@end
