//
//  MUSMoodViewController.m
//  Muse
//
//  Created by Leo Kwan on 10/13/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSMoodViewController.h"
#import "MUSMoodCollectionViewCell.h"

#define CELL_PADDING  (self.view.frame.size.width * .05f)


@interface MUSMoodViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *moods;

@end

@implementation MUSMoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate =self;
    self.collectionView.dataSource = self;
    
    [self.navigationController.navigationBar setHidden:NO];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.moods = [[NSMutableArray alloc] init];
    [self.moods addObjectsFromArray:@[@"Happy", @"yoyo", @"Brat", @"Ty",@"yo", @"yoyo", @"Brat", @"Ty",@"yo", @"yoyo", @"Brat", @"Ty",@"yo", @"yoyo", @"Brat", @"Ty",@"yo", @"yoyo", @"Brat", @"Ty",@"yo", @"yoyo", @"Brat", @"Ty"]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
    datasetCell.backgroundColor = [UIColor blueColor]; // highlight selection
    NSLog(@"%@", self.moods[indexPath.row]);
    
}



#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
//
//


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.moods.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    MUSMoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moodCollectionCell" forIndexPath:indexPath];
    cell.moodLabel.text = self.moods[indexPath.row];
//    cell.moodImageView.image = [
    
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
