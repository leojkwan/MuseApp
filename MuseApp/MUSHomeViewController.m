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
#import "MUSActionView.h"
#import "MUSGreetingManager.h"

@import QuartzCore;

@interface MUSHomeViewController ()<CurrentTimeDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,assign) TimeOfDay time;

@property (strong, nonatomic) MUSColorSheet* colorStore;
@property (strong, nonatomic) MUSTimeFetcher* timeManager;
@property (strong, nonatomic) MUSGreetingManager* greetManager;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *cardsArray;
@property (nonatomic, assign) CGFloat lastContentOffset;


@end


@implementation MUSHomeViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    [self setUpCurrentTime];
    self.colorStore = [MUSColorSheet sharedInstance];
    [self setUpScrollContent];
    [self setUpPagingControl];
  }


-(void) setUpScrollContent {
    
    MUSActionView *actionView = [[MUSActionView alloc] init];
    self.cardsArray = @[actionView,actionView];
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.scrollView.mas_height).multipliedBy(self.cardsArray.count);
    }];
    [self.scrollContentView addSubview:actionView];
    [actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(self.scrollView);
        make.left.and.top.and.right.equalTo(self.scrollContentView);
    }];
}

-(void)setUpCurrentTime {
    self.timeManager = [[MUSTimeFetcher alloc] init];
    self.timeManager.delegate = self;
    self.time = self.timeManager.timeOfDay;
    self.dateLabel.text = [[NSDate date] returnDayMonthDateFromDate];
    [self presentGreeting];
}

-(void)setUpPagingControl {
    self.pageControl.numberOfPages = self.cardsArray.count;
    self.pageControl.currentPage = 0;
    self.pageControl.transform = CGAffineTransformMakeRotation(M_PI_2);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    static NSInteger previousPage = 0;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    NSInteger page = floor((self.scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
    self.pageControl.currentPage = page;
}

//-(void)setUpIconTint:(UIColor *)color {
//    UIImage *image = [[UIImage imageNamed:@"icon1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [self.action1Icon setImage:image forState:UIControlStateNormal];
//    self.action1Icon.tintColor = color;
//}


-(void)updatedTime:(NSString *)timeString {
    self.timeLabel.text = timeString;
}

-(void)presentGreeting {
     NSString *userFirstName = [[NSUserDefaults standardUserDefaults] stringForKey:@"userFirstName"];
    self.greetManager = [[MUSGreetingManager alloc] initWithTimeOfDay:self.time firstName:userFirstName];
    self.greetingLabel.text = [self.greetManager usergreeting];
}


@end
