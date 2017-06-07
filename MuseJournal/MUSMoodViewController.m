//
//  MUSMoodViewController.m
//  Muse

#import "MUSMoodViewController.h"
#import "MUSMoodCollectionViewCell.h"
#import "UIColor+MUSColors.h"
#import "UIImage+ExtraMethods.h"
#import "UIImageView+ExtraMethods.h"
#import "MUSDataStore.h"
#import  "MUSTagManager.h"
#import "MBProgressHUD.h"

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
  
  
  [self setUp];
  //display HUD until the views finish loading in viewDidAppear.
  [MBProgressHUD showHUDAddedTo: self.view animated:YES];
  
}

-(void)setUp {
  self.store = [MUSDataStore sharedDataStore];
  [self.destinationToolBar setHidden:YES];
  
  self.collectionView.delegate =self;
  self.collectionView.dataSource = self;
  
  self.moodString = [[NSMutableArray alloc] init];
  self.moodImages = [[NSMutableArray alloc] init];
  
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:true];
  
  for (NSArray *mood in [MUSTagManager returnArrayForTagImages]) {
    [self.moodString addObject:mood[0]];
    [self.moodImages addObject:mood[1]];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
  }
  [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


-(void)popVC {
  [self.destinationToolBar setHidden:NO];
  [self.navigationController popViewControllerAnimated:YES];
  //    [self dismissViewControllerAnimated:YES completion:nil];
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
  [cell.moodImageView setImageToColorTint:[UIColor whiteColor]];
  
  
  [self animateCell:cell];


  return cell;
}


-(void)animateCell:(MUSMoodCollectionViewCell*)cell {
  
  CGRect frame = cell.contentView.frame;
  cell.contentView.frame = frame;
  cell.contentView.alpha = 0;
  
  
  [UIView animateWithDuration:0.45 animations:^() {
    CGRect frame = cell.contentView.frame;
    cell.contentView.frame = frame;
    cell.contentView.alpha = 1;
    
  } completion: nil];

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
  
  return CELL_PADDING *2;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  
  
  return UIEdgeInsetsMake(CELL_PADDING,CELL_PADDING,CELL_PADDING,CELL_PADDING);  // top, left, bottom, right
}


@end
