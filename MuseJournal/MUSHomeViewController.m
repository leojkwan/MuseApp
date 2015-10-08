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
#import <StoreKit/StoreKit.h>
#import "MUSITunesClient.h"
#import "MUSConstants.h"

@import QuartzCore;

@interface MUSHomeViewController ()<CurrentTimeDelegate, UIScrollViewDelegate, ActionViewDelegate, SKStoreProductViewControllerDelegate>
// SKPaymentTransactionObserver add this to protocol when you implement iAD

@property (nonatomic,assign) TimeOfDay time;


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


@end


@implementation MUSHomeViewController
//
//#define kExtraThemeProductID @"iapdemo_extra_colors_col1"
//#define kRemoveAdsProductID @"com.leojkwan.muse.removeads"
//
-(void)viewDidLoad {
    [super viewDidLoad];

    
    self.scrollView.delegate = self;
    [self setUpCurrentTime];
    self.colorStore = [MUSColorSheet sharedInstance];
    [self setUpScrollContent];
}


//- (IBAction)tapsRemoveAds{
//    NSLog(@"User requests to remove ads");
//
//    if([SKPaymentQueue canMakePayments]){
//        NSLog(@"User can make payments");
//
//        //If you have more than one in-app purchase, and would like
//        //to have the user purchase a different product, simply define
//        //another function and replace kRemoveAdsProductIdentifier with
//        //the identifier for the other product
//
//        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
//        productsRequest.delegate = self;
//        [productsRequest start];
//
//    }
//    else{
//        NSLog(@"User cannot make payments due to parental controls");
//        //this is called the user cannot make payments, most likely due to parental controls
//    }
//}
//
//- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
//    SKProduct *validProduct = nil;
//    int count = [response.products count];
//    if(count > 0){
//        validProduct = [response.products objectAtIndex:0];
//        NSLog(@"Products Available!");
//        [self purchase:validProduct];
//    }
//    else if(!validProduct){
//        NSLog(@"No products available");
//        //this is called if your product id is not valid, this shouldn't be called unless that happens.
//    }
//}
//
//- (IBAction)purchase:(SKProduct *)product{
//    SKPayment *payment = [SKPayment paymentWithProduct:product];
//
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
//}
//
//- (IBAction) restore{
//    //this is called when the user restores purchases, you should hook this up to a button
//    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
//}
//
//- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
//{
//    NSLog(@"received restored transactions: %i", queue.transactions.count);
//    for(SKPaymentTransaction *transaction in queue.transactions){
//        if(transaction.transactionState == SKPaymentTransactionStateRestored){
//            //called when the user successfully restores a purchase
//            NSLog(@"Transaction state -> Restored");
//
//            [self doRemoveAds];
//            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//            break;
//        }
//    }
//}
//
//- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
//    for(SKPaymentTransaction *transaction in transactions){
//        switch(transaction.transactionState){
//            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
//                //called when the user is in the process of purchasing, do not add any of your own code here.
//                break;
//            case SKPaymentTransactionStatePurchased:
//                //this is called when the user has successfully purchased the package (Cha-Ching!)
//                [self doRemoveAds]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
//                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//                NSLog(@"Transaction state -> Purchased");
//                break;
//            case SKPaymentTransactionStateRestored:
//                NSLog(@"Transaction state -> Restored");
//                //add the same code as you did from SKPaymentTransactionStatePurchased here
//                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//                break;
//            case SKPaymentTransactionStateFailed:
//                //called when the transaction does not finish
//                if(transaction.error.code == SKErrorPaymentCancelled){
//                    NSLog(@"Transaction state -> Cancelled");
//                    //the user cancelled the payment ;(
//                }
//                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//                break;
//        }
//    }
//}
//- (void)doRemoveAds{
//    ADBannerView *banner;
//    [banner setAlpha:0];
//    areAdsRemoved = YES;
//    removeAdsButton.hidden = YES;
//    removeAdsButton.enabled = NO;
//    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"areAdsRemoved"];
//    //use NSUserDefaults so that you can load whether or not they bought it
//    //it would be better to use KeyChain access, or something more secure
//    //to store the user data, because NSUserDefaults can be changed.
//    //You're average downloader won't be able to change it very easily, but
//    //it's still best to use something more secure than NSUserDefaults.
//    //For the purpose of this tutorial, though, we're going to use NSUserDefaults
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//
//

-(void) setUpScrollContent {
    MUSActionView* actionView = [[MUSActionView alloc] init];
    actionView.delegate = self;
    
    MUSActionView *actionView2 = [[MUSActionView alloc] init];
    MUSActionView *actionView3 = [[MUSActionView alloc] init];
    
    NSArray *cardsArray= @[actionView,actionView2, actionView3];
    
    
    // set up contraints for scroll content view
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.scrollView.mas_height).multipliedBy(cardsArray.count);
    }];
    
    // set up contraints for main action card
    [self.scrollContentView addSubview:actionView];
    [actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(self.scrollView);
        make.left.and.top.and.right.equalTo(self.scrollContentView);
    }];
    
    // i at 0 is the action view
    for (int i = 1; i < cardsArray.count; i++) {
        [self.scrollContentView addSubview:cardsArray[i]];
        [cardsArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(self.scrollView);
            make.left.and.right.equalTo(self.scrollContentView);
            UIView *lastCard = cardsArray[i-1];
            // append current card top to last card bottom
            make.top.equalTo(lastCard.mas_bottom);
        }];
    }
    
    [self setUpPagingControl:cardsArray.count];
}

-(void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}


-(void)didSelectAddButton:(id)sender {
    
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
    self.dateLabel.text = [NSString stringWithFormat:@"It's %@.", [[NSDate date] returnDayMonthDateFromDate]];
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
    self.greetingLabel.text = [self.greetManager usergreeting];
}

- (IBAction)settingButtonTapped:(id)sender {
    
}



@end
