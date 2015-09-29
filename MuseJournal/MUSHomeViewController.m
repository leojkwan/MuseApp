//
//  MUSHomeViewController.m
//  MuseApp
//
//  Created by Leo Kwan on 9/18/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSHomeViewController.h"
#import "MUSDetailEntryViewController.h"
#import "MUSAllEntriesViewController.h"
#import "NSDate+ExtraMethods.h"
#import <Masonry.h>
#import "UIButton+ExtraMethods.h"
#import "MUSTimeFetcher.h"
#import "MUSColorSheet.h"
#import "MUSActionView.h"
#import "MUSGreetingManager.h"

@import QuartzCore;

@interface MUSHomeViewController ()<CurrentTimeDelegate, UIScrollViewDelegate, ActionViewDelegate>


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

// xibs
@property (strong, nonatomic) MUSActionView* actionView;


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
    
    self.actionView = [[MUSActionView alloc] init];
    self.actionView.delegate = self;
    MUSActionView *actionView2 = [[MUSActionView alloc] init];
    MUSActionView *actionView3 = [[MUSActionView alloc] init];
    MUSActionView *actionView4 = [[MUSActionView alloc] init];
    MUSActionView *actionView5 = [[MUSActionView alloc] init];

    self.cardsArray = @[self.actionView,actionView2, actionView3, actionView4, actionView5];
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.scrollView.mas_height).multipliedBy(self.cardsArray.count);
    }];
    
    [self.scrollContentView addSubview:self.cardsArray[0]];
    [self.cardsArray[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(self.scrollView);
        make.left.and.top.and.right.equalTo(self.scrollContentView);
    }];
    
    [self.scrollContentView addSubview:self.cardsArray[1]];
    [self.cardsArray[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(self.scrollView);
        make.left.and.right.equalTo(self.scrollContentView);
        make.top.equalTo(self.actionView.mas_bottom);
    }];

}

-(void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}


-(void)didSelectAddButton:(id)sender {
//    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/album/roar/id690928033?i=690928331&app=music"];
//    [[UIApplication sharedApplication] openURL:url];

    NSLog(@" add");
    // do any setup you need for myNewVC
    MUSDetailEntryViewController *addEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEntryVC"];
    [self.navigationController pushViewController: addEntryVC animated:YES];
}

-(void)didSelectShuffleButton:(id)sender {
    NSLog(@" shuffle");
    MUSDetailEntryViewController *addEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEntryVC"];
    addEntryVC.entryType = RandomSong;
    [self.navigationController pushViewController: addEntryVC animated:YES];
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
    CGFloat pageHeight = self.scrollView.frame.size.height;
    NSInteger page = floor((self.scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
    self.pageControl.currentPage = page;
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
