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
#import "MUSGreetingManager.h"

@interface MUSHomeViewController ()<CurrentTimeDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,assign) TimeOfDay time;
@property (weak, nonatomic) IBOutlet UIButton *action1Icon;
@property (weak, nonatomic) IBOutlet UIButton *action2Icon;
@property (strong, nonatomic) MUSColorSheet* colorStore;
@property (strong, nonatomic) MUSTimeFetcher* timeManager;
@property (strong, nonatomic) MUSGreetingManager* greetManager;

@property (weak, nonatomic) IBOutlet UIView *scrollContentView;

@end


@implementation MUSHomeViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCurrentTime];
    self.colorStore = [MUSColorSheet sharedInstance];
    [self setUpIconTint: [self.colorStore iconTint]];
    
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1000);
    }];
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
     NSString *userFirstName = [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"];
    self.greetManager = [[MUSGreetingManager alloc] initWithTimeOfDay:self.time firstName:userFirstName];
    self.greetingLabel.text = [self.greetManager usergreeting];
}


@end
