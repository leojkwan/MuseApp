//
//  MUSKeyboardTopBar.m
//  MuseApp
//


#import "MUSKeyboardTopBar.h"
#import <Masonry.h>
#import "UIButton+ExtraMethods.h"

@interface MUSKeyboardTopBar ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIToolbar *keyboardToolBar;
@property (nonatomic, strong) NSMutableArray *barButtonItems;

@end

@implementation MUSKeyboardTopBar




-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self commonInit];
    }
    
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}



-(instancetype)initWithToolbar{
    self = [super init];
    if (self) {
        [self commonInit];
        [self setUpToolBarButtons];
    }
    return self;
}

-(instancetype)initWithKeyboard {
    self = [super init];
    if (self) {
        [self commonInit];
        [self setUpKeyboardButtons];
    }
    return self;
}


-(void)commonInit
{
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class)
                                  owner:self
                                options:nil];
    
    // add content view to xib
    [self addSubview:self.contentView];
    

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
  }

-(void)setUpToolBarButtons {
    // create buttons array
    self.barButtonItems = [[NSMutableArray alloc] init];
    
    // set up bar buttons items in this order left to right
    [self setUpCameraButton];
    [self setUpFixedSpaceButtonOfWidth:15];
    [self setUpPinSongButton];
    [self setUpFixedSpaceButtonOfWidth:15];
    [self setUpPlaylistButton];
    [self setUpFlexSpaceButton];
    
    // after all buttons have been set... set array to toolbar
    [self.keyboardToolBar setItems:self.barButtonItems animated:YES];
    
}

-(void)setUpKeyboardButtons {
    // create buttons array
    self.barButtonItems = [[NSMutableArray alloc] init];
    
    // set up bar buttons items in this order left to right
    [self setUpCameraButton];
    [self setUpFixedSpaceButtonOfWidth:15];
    [self setUpPinSongButton];
    [self setUpFixedSpaceButtonOfWidth:15];
    [self setUpPlaylistButton];
    [self setUpFlexSpaceButton];
    [self setUpDoneButton];
    
    
    // after all buttons have been set... set array to toolbar
    [self.keyboardToolBar setItems:self.barButtonItems animated:YES];

}


#pragma mark - Create Buttons


-(void)setUpCameraButton {
    UIButton* cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [cameraButton addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    
    // set up camera bar button
    UIBarButtonItem *cameraBarButtonItem = [[UIBarButtonItem alloc]  initWithCustomView:cameraButton];
    [self.barButtonItems addObject:cameraBarButtonItem];
}

-(void)setUpPlaylistButton {
    UIButton* seePlaylistButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    [seePlaylistButton addTarget:self action:@selector(seePlaylistButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [seePlaylistButton setBackgroundImage:[UIImage imageNamed:@"equalizer"] forState:UIControlStateNormal];
    
    // set up camera bar button
    UIBarButtonItem *seePlaylistBarButtonItem = [[UIBarButtonItem alloc]  initWithCustomView:seePlaylistButton];
    [self.barButtonItems addObject:seePlaylistBarButtonItem];
}

-(void)setUpPinSongButton {

    UIButton* addSongButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [addSongButton addTarget:self action:@selector(pinSongButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [addSongButton setBackgroundImage:[UIImage imageNamed:@"addToPlaylist"] forState:UIControlStateNormal];
    
    UIBarButtonItem *addSongBarButtonItem = [[UIBarButtonItem alloc]  initWithCustomView:addSongButton];
    [self.barButtonItems addObject:addSongBarButtonItem];
}


-(void)setUpFlexSpaceButton {
    UIBarButtonItem *flexibleSpaceBarButtonItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self.barButtonItems addObject:flexibleSpaceBarButtonItem];
}

-(void)setUpFixedSpaceButtonOfWidth:(CGFloat)width {
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = width;
    [self.barButtonItems addObject:fixedSpaceBarButtonItem];
}

-(void)setUpDoneButton {

    // set up done bar button
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:@selector(doneButtonPressed:)];
    
    NSDictionary *doneBarButtonItemAppearanceDict = @{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0], NSForegroundColorAttributeName: [UIColor yellowColor]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:doneBarButtonItemAppearanceDict forState:UIControlStateNormal];
    [self.barButtonItems addObject:doneBarButtonItem];
}





#pragma mark - Button Actions


-(void)seePlaylistButtonPressed:(id)sender {
    NSLog(@"seePlaylistButtonPressed");
    [self.delegate didSelectPlaylistButton:sender];
}

-(void)doneButtonPressed:(id)sender{
    NSLog(@"doneButtonPressed");
    [self.delegate didSelectDoneButton:sender];;
}


-(void)pinSongButtonPressed:(id)sender {
    NSLog(@"pinSongButtonPressed");
    [self.delegate didSelectAddSongButton:sender];
}


#pragma mark - Button Pressed methods
-(void)cameraButtonPressed:(id)sender{
    NSLog(@"cameraButtonPressed");
    [self.delegate didSelectCameraButton:sender];
}

//
//-(void)setUpRightNavBar {
//    UIButton *pinSongButton = [UIButton createPinSongButton];
//    [pinSongButton addTarget:self action:@selector(pinSongButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *pinSongBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:pinSongButton];
//    
//    UIButton *playlistButton = [UIButton createPlaylistButton];
//    [playlistButton addTarget:self action:@selector(playlistButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *playlistBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:playlistButton];
//    
//    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonTapped:)];
//    
//    UIBarButtonItem *uploadImageBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(selectPhoto:)];
//    
//    self.navigationItem.rightBarButtonItems = @[saveBarButtonItem, playlistBarButtonItem, pinSongBarButtonItem, uploadImageBarButtonItem];
//}


@end
