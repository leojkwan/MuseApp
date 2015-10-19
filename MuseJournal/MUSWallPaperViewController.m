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
#import <Masonry.h>
#import <StoreKit/StoreKit.h>
#import "MUSActionView.h"

#define CELL_PADDING (self.view.frame.size.height * .02f)
// 5 cells times 10 for left and right padding...

#define PREMIUM_WALLPAPER_7 @"MUS_extra_wallpaper_7"



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
@property (strong, nonatomic) NSNumber *wallpaperIsPurchased;
@property (strong, nonatomic) NSDictionary *wallpaperDictionary;
@property (weak, nonatomic) IBOutlet UILabel *setWallpaperLabel;

@end

@implementation MUSWallPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wallpaperCollectionView.delegate = self;
    self.wallpaperCollectionView.dataSource = self;
    
//    [self.wallpaperCollectionView registerClass:[MUSWallpaperCollectionViewCell class] forCellWithReuseIdentifier:@"wallpaperCollectionCell"];

    self.wallpaperDictionary = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"purchasedWallpapers"] mutableCopy];
    self.wallpaperArray = [MUSWallpaperManager returnArrayForWallPaperImages];
    [self configureNavBar];
    [self setUpWallpaperUI];
    
    
    [self animateWallpaperMenu];
    [self setUpCallToActionLabel];
    
}

-(void)setUpCallToActionLabel {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wallpaperLabelPressed)];
    [self.setWallpaperLabel addGestureRecognizer:tap];
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
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)updateUserBackgroundImage {
    
    [[NSUserDefaults standardUserDefaults] setInteger:self.collectionViewCurrentIP forKey:@"background"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
//                                    [[NSUserDefaults standardUserDefaults] setInteger:self.collectionViewCurrentIP forKey:@"background"];
//                                    [[NSUserDefaults standardUserDefaults] synchronize];
//                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBackground" object:nil userInfo:[NSDictionary dictionaryWithObject: @(self.collectionViewCurrentIP) forKey:@"wallpaperIndex"]];
                                    
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


-(UIAlertController *)returnPurchaseWallpaperController {
    UIAlertController *alertController= [UIAlertController
                                         alertControllerWithTitle:nil
                                         message:[NSString stringWithFormat: @"%@", [self.wallpaperNameLabel.text uppercaseString]]
                                         preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Purchase Premium Theme", @"Purchase Premium Theme")
                                style:UIAlertActionStyleDestructive
                                handler:^(UIAlertAction *action) {
//                                    
//                                    
//                                    if([SKPaymentQueue canMakePayments]){
//                                        NSLog(@"User can make payments");
//                                        
//                                        //If you have more than one in-app purchase, and would like
//                                        //to have the user purchase a different product, simply define
//                                        //another function and replace kRemoveAdsProductIdentifier with
//                                        //the identifier for the other product
//                                        
//                                        
//                                        
//                                        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:PREMIUM_WALLPAPER_7]];
//                                        productsRequest.delegate = self;
//                                        [productsRequest start];
//
//                                        
//                                    }
//                                    else{
//                                        NSLog(@"User cannot make payments due to parental controls");
//                                        //this is called the user cannot make payments, most likely due to parental controls
//                                    }
                                    
                                    
                                    // figure this out
                                    //
                                    //                                    [[NSUserDefaults standardUserDefaults] setInteger:self.collectionViewCurrentIP forKey:@"background"];
                                    //                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    //                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBackground" object:nil userInfo:[NSDictionary dictionaryWithObject: @(self.collectionViewCurrentIP) forKey:@"wallpaperIndex"]];
                                    
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




- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    NSInteger count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}



- (void)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}



- (IBAction) restore{
    //this is called when the user restores purchases, you should hook this up to a button
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)doAddWallpaper{
    [self.view setBackgroundColor:[UIColor blueColor]];
//    areAdsRemoved = YES
    //set the bool for whether or not they purchased it to YES, you could use your own boolean here, but you would have to declare it in your .h file
    
    // save new key value to dictiionary
    
    NSMutableDictionary *updatedDictionary = [self.wallpaperDictionary mutableCopy];
    [updatedDictionary setObject:[NSNumber numberWithBool:YES] forKey:self.wallpaperNameLabel.text]; // SET YES TO THE CURRENT WALLPAPER
    
    // overwrite existing dictionary
    [[NSUserDefaults standardUserDefaults] setObject:updatedDictionary forKey:@"purchasedWallpapers"];
    
    // set new wallpaper preference after successful purchase
    [self updateUserBackgroundImage];
    
    // SAVE
    [[NSUserDefaults standardUserDefaults] synchronize];
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
                
                NSLog(@"THIS IS WHERE YOU MUSE ADD YES TO NSUSERDEFAULTS");
                [self doAddWallpaper];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
            case SKPaymentTransactionStateDeferred:
                
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled or deferred ");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}


- (void)wallpaperLabelPressed {
    
    
    UIAlertController *alertController;
    
    if ([self.wallpaperIsPurchased  isEqual: @1])
        alertController = [self returnSaveWallpaperController];
    else // not purchased
        alertController = [self returnPurchaseWallpaperController];
    

    
    
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        
        //If you have more than one in-app purchase, and would like
        //to have the user purchase a different product, simply define
        //another function and replace kRemoveAdsProductIdentifier with
        //the identifier for the other product
        
        
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:PREMIUM_WALLPAPER_7]];
        productsRequest.delegate = self;
        [productsRequest start];
        
        
    }
    else{
        NSLog(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
    }

    
    
//    [self presentViewController:alertController animated:YES completion:nil];
    
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
    
    // Set Wallpaper Icon based on Purchases
    self.wallpaperIsPurchased = [self.wallpaperDictionary objectForKey:selectedWallpaperName];
    
    // Change Call To Action Button
    if  ([self.wallpaperIsPurchased isEqual:@1])
        self.setWallpaperLabel.text = @"Save";
    else
        self.setWallpaperLabel.text = @"Purchase";
    
    
    [UIView transitionWithView:self.wallpaperPreviewImageView duration:0.4f  options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.wallpaperPreviewImageView.image = [MUSWallpaperManager returnArrayForWallPaperImages][indexPath.row][1];
        self.collectionViewCurrentIP = indexPath.row;
    } completion:NULL];
    
    
    // indicate the ONE selected item
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    selectedCell.layer.borderColor =  [UIColor cyanColor].CGColor;
    
    // scroll view to center selected index path
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    // pass the name of wallpaper selected
    [self updateWallpaperLabelWithText: selectedWallpaperName];
    
    
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
