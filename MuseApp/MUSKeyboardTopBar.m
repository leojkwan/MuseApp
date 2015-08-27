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

-(void)commonInit
{
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class)
                                  owner:self
                                options:nil];
    
    // add content view to xib
    [self addSubview:self.contentView];
    
    
//    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    // set content view constraints to hug whatever frame is set in VC
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    // create buttons array
    self.barButtonItems = [[NSMutableArray alloc] init];
    
    // set up bar buttons items in this order left to right
    [self setUpCameraButton];
    [self setUpFlexSpaceButton];
    [self setUpDoneButton];

    
    // after all buttons have been set... set array to toolbar
    [self.keyboardToolBar setItems:self.barButtonItems animated:YES];

}
-(void)setUpCameraButton {
    
    // keyboard buttons array
    
    // set up camera button
    UIButton* cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
    [cameraButton addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    
    // set up camera bar button
    UIBarButtonItem *cameraBarButtonItem = [[UIBarButtonItem alloc]  initWithCustomView:cameraButton];
    cameraBarButtonItem.tintColor = [UIColor yellowColor];
    [self.barButtonItems addObject:cameraBarButtonItem];
}

-(void)setUpFlexSpaceButton {
    UIBarButtonItem *flexibleSpaceBarButtonItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self.barButtonItems addObject:flexibleSpaceBarButtonItem];
}

-(void)setUpDoneButton {

    // set up done bar button
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:@selector(doneButtonPressed:)];
    
    NSDictionary *doneBarButtonItemAppearanceDict = @{NSFontAttributeName : [UIFont fontWithName:@"Avenir-Medium" size:17.0], NSForegroundColorAttributeName: [UIColor yellowColor]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:doneBarButtonItemAppearanceDict forState:UIControlStateNormal];
    [self.barButtonItems addObject:doneBarButtonItem];
}

-(void)doneButtonPressed:(id)sender{
    NSLog(@"doneButtonPressed");
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
