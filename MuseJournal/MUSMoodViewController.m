//
//  MUSMoodViewController.m
//  Muse
//
//  Created by Leo Kwan on 10/13/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSMoodViewController.h"
#import "MUSMoodCollectionViewCell.h"
#import "UIColor+MUSColors.h"
#import "UIImage+ExtraMethods.h"
#import "MUSDataStore.h"
#import  "MUSTagManager.h"

#define CELL_PADDING  (self.view.frame.size.width * .05f)


@interface MUSMoodViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *moodString;
@property (nonatomic, strong) NSMutableArray *moodImages;

@property (weak, nonatomic) IBOutlet UIButton *quitButton;
@property (nonatomic, strong) MUSDataStore *store;

@end

@implementation MUSMoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.store = [MUSDataStore sharedDataStore];
    [self.destinationToolBar setHidden:YES];
    
    self.collectionView.delegate =self;
    self.collectionView.dataSource = self;
    
    [self.quitButton setImage:[UIImage imageNamed:@"quitButton" withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    //    [self.navigationController.navigationBar setHidden:NO];
    
    
    self.moodString = [[NSMutableArray alloc] init];
    self.moodImages = [[NSMutableArray alloc] init];
    
    
    
    
    for (NSArray *mood in [MUSTagManager returnArrayForTagImages]) {
        [self.moodString addObject:mood[0]];
        [self.moodImages addObject:mood[1]];
    }
    
//    [self.moods addObjectsFromArray:@[@"Happy", @"Happy", @"Brat", @"Ty",@"yo", @"yoyo", @"Brat", @"Ty",@"yo", @"yoyo", @"Brat", @"Ty",@"yo", @"yoyo", @"Brat", @"Ty",@"yo", @"yoyo", @"Brat", @"Ty",@"yo", @"yoyo", @"Brat", @"Ty"]];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)popVC {
    [self.destinationToolBar setHidden:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backButtonPressed:(id)sender {
    [self popVC];
}

-(void)addTapGestureToContainerView {
    UITapGestureRecognizer *tapDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popVC)];
    [self.view addGestureRecognizer:tapDismiss];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    [self.delegate updateMoodLabelWithText:self.moodString[indexPath.row]];
    [self popVC];
}



#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.moodString.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    

    
    MUSMoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moodCollectionCell" forIndexPath:indexPath];
    cell.moodLabel.text = self.moodString[indexPath.row];
    cell.moodImageView.image = self.moodImages[indexPath.row];
    return cell;
}



#pragma mark - UICollectionViewLayout

// Set size of collection cell
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // make cell always 2/5 of the screen width
    CGFloat cellSizeBasedOnPadding = self.view.frame.size.width * .4f;
    return CGSizeMake(cellSizeBasedOnPadding, cellSizeBasedOnPadding);
}


// set vertical seperation of cell
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    //    CGFloat cellPadding = self.view.frame.size.width * .05f;
    return CELL_PADDING *2;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    // padding really
    //    CGFloat cellPadding = self.view.frame.size.width * .05f;
    return UIEdgeInsetsMake(CELL_PADDING,CELL_PADDING,CELL_PADDING,CELL_PADDING);  // top, left, bottom, right
}



#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
