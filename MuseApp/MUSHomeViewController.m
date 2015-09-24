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
#import "UIButton+ExtraMethods.h"
#import "MUSTimeFetcher.h"
#import "MUSColorSheet.h"


@interface MUSHomeViewController ()<CurrentTimeDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,assign) TimeOfDay time;
@property (weak, nonatomic) IBOutlet UIButton *action1Icon;
@property (weak, nonatomic) IBOutlet UIButton *action2Icon;
@property (strong, nonatomic) MUSColorSheet* colorStore;


@property (strong, nonatomic) MUSTimeFetcher* timeManager;


@end


@implementation MUSHomeViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCurrentTime];
    self.colorStore = [MUSColorSheet sharedInstance];
    [self setUpIconTint: [self.colorStore iconTint]];
}

-(void)setUpCurrentTime {
    self.timeManager = [[MUSTimeFetcher alloc] init];
    self.timeManager.delegate = self;
    self.time = self.timeManager.timeOfDay;
    self.dateLabel.text = [[NSDate date] returnDayMonthDateFromDate];
    [self presentGreeting];
}



-(void)setUpIconTint:(UIColor *)color {
    UIImage *image = [[UIImage imageNamed:@"icon1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.action1Icon setImage:image forState:UIControlStateNormal];
    self.action1Icon.tintColor = color;
}


-(void)updatedTime:(NSString *)timeString {
    self.timeLabel.text = timeString;
}

-(void)presentGreeting {

    if ( [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"]  != NULL) {
        // IF THERE IS A USERNAME
        switch (self.time) {
            case Morning:
                self.greetingLabel.text = [NSString stringWithFormat:@"Good Morning %@!", [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"]];
                break;
            case Afternoon:
                self.greetingLabel.text = [NSString stringWithFormat:@"Good Afternoon %@.", [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"]];
                break;
            case LateNight:
                self.greetingLabel.text = [NSString stringWithFormat:@"It's late at night %@.", [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"]];
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
