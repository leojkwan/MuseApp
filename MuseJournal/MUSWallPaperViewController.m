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
#import <Masonry.h>

#define CELL_PADDING (self.view.frame.size.height * .02f)


@interface MUSWallPaperViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *wallpaperCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation MUSWallPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wallpaperCollectionView.delegate = self;
    self.wallpaperCollectionView.dataSource = self;
    self.wallpaperCollectionView.allowsMultipleSelection = NO;
    self.wallpaperCollectionView.allowsSelection = YES; //this is set by default
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
//    self.navTitleLabel.attributedText = [NSAttributedString returnStringWithTitle:@"Select Theme" color:[UIColor whiteColor] undelineColor:[UIColor whiteColor] fontSize:20];
    
     [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MUSWallpaperCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"wallpaperCollectionCell" forIndexPath:indexPath];

    cell.layer.cornerRadius = 5;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 2.0f;

    
    cell.selected = YES;
//    [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    return cell;
}

- (IBAction)backbuttonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UICollectionViewLayout

// Set size of collection cell
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // make cell always 1/6 of the screen width
    CGFloat cellSizeBasedOnPadding = self.view.frame.size.width * .2f;
    return CGSizeMake(cellSizeBasedOnPadding, cellSizeBasedOnPadding);
}


// set vertical seperation of cell
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
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
    
    // indicate the ONE selected item
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    selectedCell.layer.borderColor =  [UIColor redColor].CGColor;

    // scroll view to center selected index path
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
 }

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cellToDeselect = [collectionView cellForItemAtIndexPath:indexPath];
    cellToDeselect.layer.borderColor =  [UIColor whiteColor].CGColor;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
