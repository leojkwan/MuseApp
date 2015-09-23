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

typedef enum {
    Morning,
    Afternoon,
    Evening
} TimeOfDay;

@interface MUSHomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property(strong, nonatomic)  NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,assign) TimeOfDay time;

@end

@implementation MUSHomeViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self getTimeOfDay];
    self.dateLabel.text = [[NSDate date] returnDayMonthDateFromDate];
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeStyle: NSDateFormatterShortStyle];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(targetMethod:)
                                   userInfo:nil
                                    repeats:YES];
    
    
    
    if ( [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"]  != NULL) {
        // IF THERE IS A USERNAME
        switch (self.time) {
            case Morning:
                        self.greetingLabel.text = [NSString stringWithFormat:@"Good Morning %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"]];
                break;
                case Afternoon:
                        self.greetingLabel.text = [NSString stringWithFormat:@"Good Afternoon %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"]];
            default:
                        self.greetingLabel.text = [NSString stringWithFormat:@"Good Evening %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"]];
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
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"] );
}

-(void)getTimeOfDay {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:[NSDate date]];
    NSInteger hour = [components hour];
    if(hour >= 0 && hour < 12)
        self.time = Morning;
        else if(hour >= 12 && hour < 17)
            self.time = Afternoon;
    else if(hour >= 17)
        self.time = Evening;
}


-(void)targetMethod:(id)sender
{
    NSString *currentTime = [self.dateFormatter stringFromDate: [NSDate date]];
    self.timeLabel.text = currentTime;
}


@end
