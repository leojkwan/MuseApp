//
//  MUSHomeViewController.m
//  MuseApp
//
//  Created by Leo Kwan on 9/18/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSHomeViewController.h"
#import "MUSSettingsTableViewController.h"
#import "MUSDetailEntryViewController.h"
#import "MUSAllEntriesViewController.h"

#import "NSDate+ExtraMethods.h"
#import "UIImage+ExtraMethods.h"
#import <Masonry.h>
#import "UIButton+ExtraMethods.h"
#import "MUSTimeFetcher.h"
#import "MUSColorSheet.h"
#import "MUSActionView.h"
#import "MUSGreetingManager.h"
#import <StoreKit/StoreKit.h>
//#import "MUSITunesClient.h"
#import "IntroViewController.h"
#import "MUSWallpaperManager.h"
#import "MUSMusicPlayerDataStore.h"
//#import "MUSWallPaperViewController.h"
#import "MUSNavigationBar.h"
#import "MUSSettingsNavigationController.h"


@import QuartzCore;

@interface MUSHomeViewController ()<CurrentTimeDelegate, UIScrollViewDelegate, ActionViewDelegate, SKStoreProductViewControllerDelegate>

@property (nonatomic,assign) TimeOfDay time;
@property (strong, nonatomic) NSArray *cardsArray;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) MUSColorSheet* colorStore;
@property (strong, nonatomic) MUSTimeFetcher* timeManager;
@property (strong, nonatomic) MUSGreetingManager* greetManager;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong,nonatomic)  UIImageView *upChevronButtonView;
@property (strong,nonatomic)  UIImageView *downChevronButtonView;
@property (nonatomic, strong) MUSMusicPlayerDataStore *sharedMusicDataStore;


@end


@implementation MUSHomeViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.colorStore = [MUSColorSheet sharedInstance];
    self.sharedMusicDataStore = [MUSMusicPlayerDataStore sharedMusicPlayerDataStore];
    [self setUpScrollContent];
    [self configureUILabelColors];
    [self setUpCurrentTime];
    [self setUpScrollButtons];
}


-(void)viewWillAppear:(BOOL)animated   {
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
        if ([[NSUserDefaults standardUserDefaults]
             boolForKey:@"firstTimeUser"] == YES) {
    NSString * storyboardName = @"Walkthrough";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    IntroViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"walkthrough"];
    [self.navigationController pushViewController:controller animated:NO];
        }
}



-(void)setUpScrollButtons {
    
//    NSInteger userWallpaperPreference = [[NSUserDefaults standardUserDefaults] integerForKey:@"background"]; // this is an NSINTEGER
//    
//    self.upChevronButtonView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"up" withColor:[MUSWallpaperManager returnTextColorForWallpaperIndex:userWallpaperPreference]]];
//    self.downChevronButtonView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"down" withColor:[MUSWallpaperManager returnTextColorForWallpaperIndex:userWallpaperPreference]]];
//    
//    
//    // MASONRY CONSTRAINTS FOR UP BUTTON
//    
//    [self.contentView addSubview:self.upChevronButtonView];
//    [self.upChevronButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.view.mas_width).dividedBy(12);
//        make.height.equalTo(self.view.mas_width).dividedBy(20);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.bottom.equalTo(self.scrollView.mas_top).with.offset(-15);
//    }];
//    
//    // MASONRY CONSTRAINTS FOR DOWN BUTTON
//    
//    [self.contentView addSubview:self.downChevronButtonView];
//    [self.downChevronButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.view.mas_width).dividedBy(12);
//        make.height.equalTo(self.view.mas_width).dividedBy(20);
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.top.equalTo(self.scrollView.mas_bottom).with.offset(15);
//    }];
//    
//    // ADD TAP GESTURES FOR UP AND DOWN BUTTONS
//    UITapGestureRecognizer *upTap = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(scrollUpButtonPressed)];
//    [self.upChevronButtonView addGestureRecognizer:upTap];
//    
//    UITapGestureRecognizer *downTap = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(scrollDownButtonPressed)];
//    [self.downChevronButtonView addGestureRecognizer:downTap];
//
//    [self setScrollInteraction:YES];
    
    NSDictionary *updatedDictionary = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"purchasedWallpapers"] mutableCopy];
    NSLog(@"%@",updatedDictionary);
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    [self configureUILabelColors];
    [self setUpCurrentTime];

    NSDictionary *updatedDictionary = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"purchasedWallpapers"] mutableCopy];
    NSLog(@"%@",updatedDictionary);
}


-(void)configureUILabelColors {
    
    // SET PRIMARY FONT COLOR BASED ON WALLPAPER SELECTION
    NSInteger userWallpaperPreference = [[NSUserDefaults standardUserDefaults] integerForKey:@"background"]; // this is an NSINTEGER
    self.greetingLabel.textColor = [MUSWallpaperManager returnTextColorForWallpaperIndex:userWallpaperPreference];
    self.dateLabel.textColor = [MUSWallpaperManager returnTextColorForWallpaperIndex:userWallpaperPreference];
    
    self.upChevronButtonView.image = [UIImage imageNamed:@"up" withColor:[MUSWallpaperManager returnTextColorForWallpaperIndex:userWallpaperPreference]];
    self.downChevronButtonView.image = [UIImage imageNamed:@"down" withColor:[MUSWallpaperManager returnTextColorForWallpaperIndex:userWallpaperPreference]];
}


-(void) setUpScrollContent {
    MUSActionView* actionView = [[MUSActionView alloc] init];
    actionView.delegate = self;
    
    
    self.cardsArray= @[actionView];
    
    
    // set up contraints for scroll content view
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.scrollView.mas_height).multipliedBy(self.cardsArray.count);
    }];
    
    // set up contraints for main action card
    [self.scrollContentView addSubview:actionView];
    [actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(self.scrollView);
        make.left.and.top.and.right.equalTo(self.scrollContentView);
    }];
    
    // i at 0 is the action view
    for (int i = 1; i < self.cardsArray.count; i++) {
        [self.scrollContentView addSubview:self.cardsArray[i]];
        [self.cardsArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(self.scrollView);
            make.left.and.right.equalTo(self.scrollContentView);
            UIView *lastCard = self.cardsArray[i-1];
            // append current card top to last card bottom
            make.top.equalTo(lastCard.mas_bottom);
        }];
    }
    
    [self setUpPagingControl:self.cardsArray.count];
}

-(void)setScrollInteraction:(BOOL)on {
    [self.downChevronButtonView setUserInteractionEnabled:on];
    [self.upChevronButtonView setUserInteractionEnabled:on];
    [self.scrollView setUserInteractionEnabled:on];
}

- (void)scrollUpButtonPressed {
    if (self.pageControl.currentPage  != 0) {
        [self setScrollInteraction:NO];
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y - self.view.frame.size.height/3) animated:YES];
    }
}

- (void)scrollDownButtonPressed {
    if (self.pageControl.currentPage  < self.cardsArray.count -1) {
        [self setScrollInteraction:NO];
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y + self.view.frame.size.height/3) animated:YES];
    }
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //  TURN OFF INTERACTION DURING SCROLL ANIMATION,
    // SCREWS OFF CONTENT OFFSET IF USER FLICKS IT BACK AND FORTH BEFORE REACHING END
    [self setScrollInteraction:YES];
}



-(void)didSelectAddButton:(id)sender {
    MUSDetailEntryViewController *addEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEntryVC"];
    [self.navigationController pushViewController: addEntryVC animated:YES];
}

-(void)didSelectShuffleButton:(id)sender {
    MUSDetailEntryViewController *addEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEntryVC"];
    addEntryVC.entryType = RandomSong;
    [self.navigationController pushViewController: addEntryVC animated:YES];
    
}



-(void)setUpCurrentTime {
    self.timeManager = [[MUSTimeFetcher alloc] init];
    self.timeManager.delegate = self;
    self.time = self.timeManager.timeOfDay;
    self.dateLabel.text = [[NSDate date] returnDayMonthDateFromDate     ];
    [self presentGreeting];
}

-(void)setUpPagingControl:(NSInteger)pages {
    self.pageControl.numberOfPages = pages;
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
    self.greetingLabel.text = self.greetManager.userGreeting;
}

- (IBAction)settingButtonTapped:(id)sender {
    
    
    // All this code to make the height of the nav bar normal and it didn't work...
    MUSNavigationBar *navBar = [[MUSNavigationBar alloc] init];
    MUSSettingsNavigationController *navController = [[MUSSettingsNavigationController alloc] initWithNavigationBarClass:[navBar class] toolbarClass:[UIToolbar class]];
    [navBar setNormalHeight];
    MUSSettingsTableViewController *settingsVC = (MUSSettingsTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"settingsVC"];

    [navController setViewControllers:@[settingsVC] animated:NO];
    [self presentViewController:navController animated:YES completion:nil];
    
}



@end
