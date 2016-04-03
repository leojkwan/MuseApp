//
//  MUSWallPaperViewController.m
//  Muse
//
//  Created by Leo Kwan on 10/14/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//



#import "MUSWallPaperViewController.h"
#import "MUSWallpaperCollectionViewCell.h"
#import "NSAttributedString+MUSExtraMethods.h"
#import "UIImage+ExtraMethods.h"
#import "MUSWallpaperManager.h"
#import <StoreKit/StoreKit.h>
#import "MUSActionView.h"
#import <MBProgressHUD.h>
#import "MUSNotificationManager.h"
#import "UIColor+MUSColors.h"

#define CELL_PADDING (self.view.frame.size.height * .02f)
// 5 cells times 10 for left and right padding...

//#define PREMIUM_WALLPAPER_7 @"MUS_extra_wallpaper_7"

@interface MUSWallPaperViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (weak, nonatomic) IBOutlet UICollectionView *wallpaperCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property(strong,nonatomic) NSArray *wallpaperArray;
@property(nonatomic, assign) BOOL initialScrollDone;
@property (weak, nonatomic) IBOutlet UIImageView *wallpaperPreviewImageView;
@property (weak, nonatomic) IBOutlet UILabel *wallpaperNameLabel;
@property(nonatomic, assign)  NSInteger userWallpaperPreference;
@property(nonatomic, assign)  NSInteger collectionViewCurrentIP;
@property (weak, nonatomic) IBOutlet MUSActionView *actionview;
@property (strong, nonatomic) NSNumber *selectedWallpaperIsPurchased;
@property (strong, nonatomic) NSMutableDictionary *wallpaperDictionary;
@property (weak, nonatomic) IBOutlet UILabel *setWallpaperLabel;
@property (weak, nonatomic) IBOutlet UILabel *restorePurchasesLabel;
@property (strong, nonatomic) SKProduct *selectedPremiumProduct;

@end

@implementation MUSWallPaperViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.wallpaperCollectionView.delegate = self;
  self.wallpaperCollectionView.dataSource = self;
  // SET TO 1 BECAUSE WALLPAPER SHOWN IS ALREADY OWNED
  self.selectedWallpaperIsPurchased = @1;
  
  
  self.wallpaperDictionary = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"purchasedWallpapers"] mutableCopy];
  self.wallpaperArray = [MUSWallpaperManager returnArrayForWallPaperImages];
  [self configureNavBar];
  [self setUpWallpaperUI];
  
  
  [self animateWallpaperMenu];
  [self setUpCallToActionLabels];
  
}

-(void)setUpCallToActionLabels {
  UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wallpaperLabelPressed)];
  [self.setWallpaperLabel addGestureRecognizer:tap1];
  
  UITapGestureRecognizer *tap2= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restorePurchasesPressed)];
  [self.restorePurchasesLabel addGestureRecognizer:tap2];
}

-(void)setUpWallpaperUI {
  // SET WALL PAPER LABEL
  self.userWallpaperPreference = [[NSUserDefaults standardUserDefaults] integerForKey:@"background"]; // this is an NSINTEGER
  self.wallpaperNameLabel.text =   [MUSWallpaperManager returnArrayForWallPaperImages][self.userWallpaperPreference][0];     // [0] IS STRING
  
  // SET WALL PAPER
  self.wallpaperPreviewImageView.image =  [MUSWallpaperManager returnArrayForWallPaperImages][self.userWallpaperPreference][1];    // [1] IS IMAGE
}


-(void) animateWallpaperMenu {
  // animate wallpaper menu
  self.contentView.alpha = 0;
  [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    self.contentView.alpha = 1;
  }completion:nil];
}


- (void)viewDidLayoutSubviews {
  // If we haven't done the initial scroll, do it once.
  [self performSelector:@selector(scrollToUserWallpaperAtIP) withObject:self afterDelay:0.25];
}

-(void)scrollToUserWallpaperAtIP {
  
  if (!self.initialScrollDone) {
    self.initialScrollDone = YES;
    NSIndexPath *selectedIP = [NSIndexPath indexPathForItem:self.userWallpaperPreference inSection:0];
    [self.wallpaperCollectionView scrollToItemAtIndexPath:selectedIP atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    /** Update text colors */
    [self updateColorContrastForIndexPath:selectedIP];
  }
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
}

-(void)configureNavBar {
  [self.navigationController.navigationBar setHidden:YES];
  self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.wallpaperArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  MUSWallpaperCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"wallpaperCollectionCell" forIndexPath:indexPath];
  
  cell.wallpaperImageView.image = self.wallpaperArray[indexPath.row][1];
  cell.wallpaperImageView.contentMode = UIViewContentModeScaleAspectFill;
  //
  NSString *wallpaperName = self.wallpaperArray[indexPath.row][0];
  NSNumber *wallpaperPurchasedBOOL = [self.wallpaperDictionary objectForKey:wallpaperName];
  
  
  // present either buy or set wallpaper action sheet
  
  if ([wallpaperPurchasedBOOL isEqual:@1]) // YES
    cell.wallpaperIconImageView.image = nil;
  else
    cell.wallpaperIconImageView.image = [UIImage imageNamed:@"lock"];
  
  
  return cell;
}

- (IBAction)backbuttonPressed:(id)sender {
  [self.navigationController.navigationBar setHidden:NO];
  [self.navigationController popViewControllerAnimated:YES];
}


-(void)updateUserBackgroundImage {
  
  // SAVE USER BACKGROUND STATE
  [[NSUserDefaults standardUserDefaults] setInteger:self.collectionViewCurrentIP forKey:@"background"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  // POST NSNOTIFICATION TO OTHER CLASSES TO UPDATE UI
  [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBackground" object:nil userInfo:[NSDictionary dictionaryWithObject: @(self.collectionViewCurrentIP) forKey:@"wallpaperIndex"]];
}




-(UIAlertController *)returnSaveWallpaperController {
  UIAlertController *alertController= [UIAlertController
                                       alertControllerWithTitle:nil
                                       message:[NSString stringWithFormat: @"Confirm %@", [self.wallpaperNameLabel.text uppercaseString]]
                                       preferredStyle:UIAlertControllerStyleActionSheet];
  [alertController addAction:[UIAlertAction
                              actionWithTitle:NSLocalizedString(@"Set as Background", @"Set as Background")
                              style:UIAlertActionStyleDestructive
                              handler:^(UIAlertAction *action) {
                                
                                [self updateUserBackgroundImage];
                                [self performSegueWithIdentifier:@"backToHomeView" sender:self];
                                
                              }]
   ];
  [alertController addAction:[UIAlertAction
                              actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                              style:UIAlertActionStyleDefault
                              handler:NULL]
   ];
  
  // for ipads
  alertController.popoverPresentationController.sourceRect = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
  alertController.popoverPresentationController.sourceView= self.contentView;
  return alertController;
}

-(void)getItemPurchaseData:(NSString*)wallpaperName {
  
  /** GET BACK PRODUCT ID NAME FOR CURRENT WALLPAPER SELECTED */
  NSSet* productIdString = [NSSet setWithObject:[MUSWallpaperManager
                                                 returnProductIDForWallPaperNamed:wallpaperName]];
  
  SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers: productIdString];
  
  productsRequest.delegate = self;
  [productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
  SKProduct *validProduct = nil;
  
  if([response.products count] > 0){
    validProduct = [response.products objectAtIndex:0];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:validProduct.priceLocale];
    NSString *formattedPrice = [numberFormatter stringFromNumber:validProduct.price];
    
    self.setWallpaperLabel.text = formattedPrice;
    self.setWallpaperLabel.userInteractionEnabled = YES;
    self.selectedPremiumProduct = [response.products objectAtIndex:0];
    
    NSLog(@"Products Available!");
  }
  else if(!validProduct){
    NSLog(@"No products available");
    //this is called if your product id is not valid, this shouldn't be called unless that happens.
  }
  [MBProgressHUD hideHUDForView:self.view animated:YES];
  
}



- (void)purchase:(SKProduct *)product{
  SKPayment *payment = [SKPayment paymentWithProduct:product];
  [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
  [[SKPaymentQueue defaultQueue] addPayment:payment];
}



- (void) restorePurchasesPressed{
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  //this is called when the user restores purchases, you should hook this up to a button
  [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
  [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
  
  
  NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
  
  if (queue.transactions.count > 0) { // IF THERE ARE ANY PURCHASES TO RESTORE
    for(SKPaymentTransaction *transaction in queue.transactions){ // for each product
      if(transaction.transactionState == SKPaymentTransactionStateRestored){
        
        NSString *productIDToRestore = transaction.payment.productIdentifier;
        
        // GET NAME OF WALLPAPER
        for (NSArray* wallpaper in [MUSWallpaperManager returnWallpaperArrayWithProductID]) {
          if ([wallpaper[1] isEqualToString:productIDToRestore]) {
            [self doAddWallpaper:wallpaper[0]]; // SET WALLPAPER KEYVALUE TO YES/ PURCHASED
          }
        }
        
        //called when the user successfully restores a purchase
        break;
      }
      [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
    // PURCHASE RESTORE SUCCESS
    [MUSNotificationManager displayNotificationWithMessage:@"Restored purchased wallpapers!" backgroundColor:[UIColor MUSCorn] textColor:[UIColor blackColor]];
    
    // VISIBLY UNLOCK RESTORED PURCHASES
    [self.wallpaperCollectionView reloadData];
  } else {
    // PURCHASE RESTORE NONE
    [MUSNotificationManager displayNotificationWithMessage:@"No wallpapers to restore." backgroundColor:[UIColor MUSSolitude] textColor:[UIColor blackColor]];
  }
  
}


-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
  [MUSNotificationManager displayNotificationWithMessage:@"Wallpaper restore failed." backgroundColor:[UIColor MUSBloodOrange] textColor:[UIColor whiteColor]];
  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}




- (void)doAddWallpaper:(NSString *)wallpaperName {
  
  // save new key value to dictiionary
  self.wallpaperDictionary[wallpaperName] = [NSNumber numberWithBool:YES];
  
  NSDictionary *newDict = [[NSDictionary alloc] initWithDictionary:self.wallpaperDictionary];
  
  // overwrite existing dictionary
  [[NSUserDefaults standardUserDefaults] setObject: newDict forKey:@"purchasedWallpapers"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  // set new wallpaper preference after successful purchase
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
  for(SKPaymentTransaction *transaction in transactions){
    switch(transaction.transactionState){
      case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
        //called when the user is in the process of purchasing, do not add any of your own code here.
        break;
      case SKPaymentTransactionStatePurchased:
        
        //this is called when the user has successfully purchased the package (Cha-Ching!)
        //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
        
        
        /** THIS IS WHERE YOU MUSE ADD YES TO NSUSERDEFAULTS
         Transaction state -> Purchased
         */
        
        [self doAddWallpaper:self.wallpaperNameLabel.text]; // SET CURRENT WALLPAPER KEY VALUE TO YES/ PURCHASED
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        
        [self updateUserBackgroundImage];
        [self performSegueWithIdentifier:@"backToHomeView" sender:self];
        
        break;
      case SKPaymentTransactionStateRestored:
        
        /** Transaction state -> Restored */
        
        break;
      case SKPaymentTransactionStateFailed:
      case SKPaymentTransactionStateDeferred:
        
        //called when the transaction does not finish
        if(transaction.error.code == SKErrorPaymentCancelled){
          /** Transaction state -> Cancelled or deferred */
          
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
          //the user cancelled the payment ;(
        }
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        break;
    }
  }
}


- (void)wallpaperLabelPressed {
  UIAlertController *alertController;
  
  if ([self.selectedWallpaperIsPurchased  isEqual: @1]) {
    alertController = [self returnSaveWallpaperController];
    [self presentViewController:alertController animated:YES completion:nil];
  }
  else { // not purchased
    
    
    if([SKPaymentQueue canMakePayments]){
      NSLog(@"User can make payments");
      
      if (_selectedPremiumProduct == nil) {
        [MUSNotificationManager displayNotificationWithMessage:@"Oops. Connect to the internet and try again!" backgroundColor:[UIColor MUSBloodOrange] textColor:[UIColor whiteColor]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
      }
      
      // Fetch product
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];

      [self purchase:self.selectedPremiumProduct];
      
    } else {
      /** This is called the user cannot make payments, most likely due to parental controls */
      NSLog(@"User cannot make payments due to parental controls");
      
    }
  }
  
}


#pragma mark - UICollectionViewLayout

// Set size of collection cell
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  // make cell always 1/5 of the screen width
  CGFloat cellSizeBasedOnPadding = self.view.frame.size.width * .2f;
  return CGSizeMake(cellSizeBasedOnPadding, cellSizeBasedOnPadding);
}

-(void)updateWallpaperLabelWithText:(NSString *)wallpaperName {
  
  self.wallpaperNameLabel.alpha = 1;
  [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    self.wallpaperNameLabel.alpha = 0;
  } completion:^(BOOL finished) {
    
    // UPDATE LABEL TO CURRENTLY SELECTED WALLPAPER NAME
    self.wallpaperNameLabel.text = wallpaperName;
    
    // animate back in
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ self.wallpaperNameLabel.alpha = 1;}
                     completion:nil];
  }];
}


// set vertical seperation of cell
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return 15;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsMake(CELL_PADDING,CELL_PADDING,CELL_PADDING,CELL_PADDING);  // top, left, bottom, right
}


-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
  selectedCell.layer.borderColor =  [UIColor cyanColor].CGColor;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
  selectedCell.layer.borderColor =  [UIColor whiteColor].CGColor;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
  
  // NAME OF SELECTED WALLPAPER
  NSString *selectedWallpaperName = [MUSWallpaperManager returnArrayForWallPaperImages][indexPath.row][0];
  
  // pass the name of wallpaper selected
  [self updateWallpaperLabelWithText: selectedWallpaperName];
  
  // Update whether selected icon is purchased
  self.selectedWallpaperIsPurchased = [self.wallpaperDictionary objectForKey:selectedWallpaperName];
  
  
  // Change Call To Action Button
  if  ([self.selectedWallpaperIsPurchased isEqual:@1]) {
    self.setWallpaperLabel.text = @"Save";
  }
  else {
    self.setWallpaperLabel.text = @"Purchase";
    // set on once price appears
    self.setWallpaperLabel.userInteractionEnabled = NO;
    [self getItemPurchaseData:selectedWallpaperName];
  }
  
  
  [UIView transitionWithView:self.wallpaperPreviewImageView duration:0.4f  options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    self.wallpaperPreviewImageView.image = [MUSWallpaperManager returnArrayForWallPaperImages][indexPath.row][1];
    self.collectionViewCurrentIP = indexPath.row;
  } completion:NULL];
  
  
  // indicate the ONE selected item
  UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
  
  selectedCell.layer.borderColor =  [UIColor cyanColor].CGColor;
  
  // scroll view to center selected index path
  [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
  
  
  
  /** Update text colors */
  [self updateColorContrastForIndexPath:indexPath];
  
}

-(void)updateColorContrastForIndexPath:(NSIndexPath *)indexPath{
  // Change Color of Action View Labels
  self.navTitleLabel.textColor = [MUSWallpaperManager returnTextColorForWallpaperIndex:indexPath.row];
  self.actionview.textLabel1.textColor = [MUSWallpaperManager returnTextColorForWallpaperIndex:indexPath.row];
  self.actionview.textLabel2.textColor = [MUSWallpaperManager returnTextColorForWallpaperIndex:indexPath.row];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cellToDeselect = [collectionView cellForItemAtIndexPath:indexPath];
  cellToDeselect.layer.borderColor =  [UIColor whiteColor].CGColor;
}



@end
