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

#define CELL_PADDING (self.view.frame.size.height * .02f)
// 5 cells times 10 for left and right padding...

@interface MUSWallPaperViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *wallpaperCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property(strong,nonatomic) NSArray *wallpaperArray;
@property(nonatomic, assign) BOOL initialScrollDone;
@property (weak, nonatomic) IBOutlet UIImageView *wallpaperPreviewImageView;
@property (weak, nonatomic) IBOutlet UILabel *wallpaperNameLabel;
@property(nonatomic, assign)  NSInteger userWallpaperPreference;
@property(nonatomic, assign)  NSInteger collectionViewCurrentIP;


@end

@implementation MUSWallPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wallpaperCollectionView.delegate = self;
    self.wallpaperCollectionView.dataSource = self;
    self.wallpaperArray = [MUSWallpaperManager returnArrayForWallPaperImages];
    [self configureNavBar];
    [self setUpWallpaperUI];
    
    
    [self animateWallpaperMenu];
}

-(void)setUpWallpaperUI {
    // SET WALL PAPER LABEL
    self.userWallpaperPreference = [[NSUserDefaults standardUserDefaults] integerForKey:@"background"];
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
    
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.cornerRadius = 5;
    cell.layer.borderWidth = 2.0f;
    cell.selected = YES; // why
    return cell;
}

- (IBAction)backbuttonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)saveButtonPressed:(id)sender {
    
    //self.collectionViewCurrentIP
    
    UIAlertController *alertController= [UIAlertController
                                         alertControllerWithTitle:nil
                                         message:[NSString stringWithFormat: @"Confirm %@", [self.wallpaperNameLabel.text uppercaseString]]
                                         preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Set as Background", @"Set as Background")
                                style:UIAlertActionStyleDestructive
                                handler:^(UIAlertAction *action) {
                                    
                                    [[NSUserDefaults standardUserDefaults] setInteger:self.collectionViewCurrentIP forKey:@"background"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBackground" object:nil userInfo:[NSDictionary dictionaryWithObject: @(self.collectionViewCurrentIP) forKey:@"wallpaperIndex"]];

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
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


#pragma mark - UICollectionViewLayout

// Set size of collection cell
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // make cell always 1/5 of the screen width
    CGFloat cellSizeBasedOnPadding = self.view.frame.size.width * .2f;
    return CGSizeMake(cellSizeBasedOnPadding, cellSizeBasedOnPadding);
}

-(void)updateWallpaperLabelWithText:(NSString *)wallpaperName {
    
    
    self.wallpaperNameLabel.alpha = 1;
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.wallpaperNameLabel.alpha = 0;
    } completion:^(BOOL finished) {

                         // change label to update wallpapername
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
    selectedCell.layer.borderColor =  [UIColor redColor].CGColor;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    selectedCell.layer.borderColor =  [UIColor whiteColor].CGColor;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [UIView transitionWithView:self.wallpaperPreviewImageView duration:0.4f  options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.wallpaperPreviewImageView.image = [MUSWallpaperManager returnArrayForWallPaperImages][indexPath.row][1];
        self.collectionViewCurrentIP = indexPath.row;
    } completion:NULL];
    
    
    // indicate the ONE selected item
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    selectedCell.layer.borderColor =  [UIColor redColor].CGColor;
    
    // scroll view to center selected index path
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    // pass the name of wallpaper selected
    [self updateWallpaperLabelWithText: [MUSWallpaperManager returnArrayForWallPaperImages][indexPath.row][0]];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cellToDeselect = [collectionView cellForItemAtIndexPath:indexPath];
    cellToDeselect.layer.borderColor =  [UIColor whiteColor].CGColor;
}



@end
