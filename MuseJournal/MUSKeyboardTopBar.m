//
//  MUSKeyboardTopBar.m
//  MuseApp
//


#import "MUSKeyboardTopBar.h"
#import <Masonry.h>
#import "UIButton+ExtraMethods.h"
#import "UIImageView+ExtraMethods.h"
#import "UIImage+ExtraMethods.h"
#import "UIColor+MUSColors.h"

#import "UIView+MUSExtraMethods.h"
#import "MUSColorSheet.h"

#define BUTTON_FRAME CGRectMake (0, 0, 40, 40)
#define BUTTON_COLOR [UIColor whiteColor] //COLOR OF BAR BUTTON ITEMS

@interface MUSKeyboardTopBar ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIToolbar *keyboardToolBar;
@property (nonatomic, strong) NSMutableArray *keyboardButtonItems;
@property (nonatomic, strong) NSMutableArray *toolbarButtonItems;


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

-(instancetype)initWithToolbarWithBackgroundColor:color {
    self = [super init];
    if (self) {
        [self commonInit];
        [self setUpToolBarButtonsWithBackgroundColor:color];
    }
    return self;
}

-(instancetype)initWithKeyboardWithBackgroundColor:color {
    self = [super init];
    if (self) {
        [self commonInit];
        [self setUpKeyboardButtonsWithBackgroundColor:color];
    }
    return self;
}

-(void)commonInit {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class)
                                  owner:self
                                options:nil];
    
    // add content view to xib
    [self addSubview:self.contentView];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self fadeInWithDuration:.2];
}


-(void)setUpToolBarButtonsWithBackgroundColor:color {
    
    self.toolbarButtonItems = [[NSMutableArray alloc] init];
    
    // set up bar buttons items in this order left to right
    [self.toolbarButtonItems addObject:[self backButton]];
    [self.toolbarButtonItems addObject:[self flexSpaceButton]];
    [self.toolbarButtonItems addObject:[self pinSongButton]];
    [self.toolbarButtonItems addObject:[self flexSpaceButton]];
    [self.toolbarButtonItems addObject:[self findSongButton]];
    [self.toolbarButtonItems addObject:[self flexSpaceButton]];
    [self.toolbarButtonItems addObject:[self playlistButton]];
    [self.toolbarButtonItems addObject:[self flexSpaceButton]];
    [self.toolbarButtonItems addObject:[self moreOptionsButton]];
    
    // SET BACKGROUND COLOR
    self.keyboardToolBar.barTintColor =color;
    
    // after all buttons have been set... set array to toolbar
    [self.keyboardToolBar setItems:self.toolbarButtonItems animated:YES];
}

-(void)setUpKeyboardButtonsWithBackgroundColor:color  {
    
    self.keyboardButtonItems = [[NSMutableArray alloc] init];
    // set up bar buttons items in this order left to right
    
    [self.keyboardButtonItems addObject:[self makeTitleButton]];
    [self.keyboardButtonItems addObject:[self cameraButton]];
    [self.keyboardButtonItems addObject:[self findSongButton]];
    [self.keyboardButtonItems addObject:[self pinSongButton]];
    [self.keyboardButtonItems addObject:[self playlistButton]];
    [self.keyboardButtonItems addObject:[self flexSpaceButton]];
    [self.keyboardButtonItems addObject:[self doneButton]];
    
    // SET BACKGROUND COLOR
    self.keyboardToolBar.barTintColor =color;

    // after all buttons have been set... set array to toolbar
    [self.keyboardToolBar setItems:self.keyboardButtonItems animated:YES];
}


#pragma mark - Create Buttons

-(UIBarButtonItem *)makeTitleButton {
    UIButton *markDownTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [markDownTitleButton setImage:[UIImage imageNamed:@"title" withColor:BUTTON_COLOR] forState:UIControlStateNormal];
    [markDownTitleButton setFrame:CGRectMake(0, 0, 35, 35)];
    [markDownTitleButton addTarget:self action:@selector(titleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *titleBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:markDownTitleButton];
    return titleBarButtonItem;
}

-(UIBarButtonItem *)findSongButton {
    UIButton *findSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [findSongButton setImage:[UIImage imageNamed:@"searchSong" withColor:BUTTON_COLOR] forState:UIControlStateNormal];
    [findSongButton setFrame:BUTTON_FRAME];
    [findSongButton addTarget:self action:@selector(pickSongButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *pickSongBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:findSongButton];
    return pickSongBarButtonItem;
}



-(UIBarButtonItem *)cameraButton {
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setImage:[UIImage imageNamed:@"addImage" withColor:BUTTON_COLOR] forState:UIControlStateNormal];
    [cameraButton setFrame:BUTTON_FRAME];
    [cameraButton addTarget:self action:@selector(cameraButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *coolCameraBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cameraButton];

    self.cameraBarButtonItem = coolCameraBarButtonItem;
    return coolCameraBarButtonItem;
}

-(UIBarButtonItem *)backButton {

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"back" withColor:BUTTON_COLOR] forState:UIControlStateNormal];

    [backButton setFrame:CGRectMake(0, 0, 30, 30)];
    
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: backButton];
    return backBarButtonItem;
}



-(UIBarButtonItem *)playlistButton {
    UIButton *playlistButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playlistButton setImage:[UIImage imageNamed:@"musicPlayer" withColor:BUTTON_COLOR] forState:UIControlStateNormal];
    [playlistButton setFrame:BUTTON_FRAME];
    [playlistButton addTarget:self action:@selector(seePlaylistButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *playlistBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:playlistButton];
    return playlistBarButtonItem;
}

-(UIBarButtonItem *)moreOptionsButton {
    UIButton *moreOptionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreOptionsButton setImage:[UIImage imageNamed:@"moreOptions" withColor:BUTTON_COLOR] forState:UIControlStateNormal];
    [moreOptionsButton setFrame:BUTTON_FRAME];
    [moreOptionsButton addTarget:self action:@selector(moreOptionsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *coolMoreOptionsBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreOptionsButton];
    
    self.moreOptionsBarButtonItem = coolMoreOptionsBarButtonItem;
    return coolMoreOptionsBarButtonItem;
}

-(UIBarButtonItem *)pinSongButton {
    
    UIButton *pinSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pinSongButton setImage:[UIImage imageNamed:@"pinSong" withColor:BUTTON_COLOR] forState:UIControlStateNormal];
    [pinSongButton setFrame:BUTTON_FRAME];
    [pinSongButton addTarget:self action:@selector(pinSongButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *pinSongButtonItem = [[UIBarButtonItem alloc] initWithCustomView:pinSongButton];
    
    return pinSongButtonItem;
}

-(UIBarButtonItem *)shareButton {
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"share" withColor:BUTTON_COLOR] forState:UIControlStateNormal];
    [shareButton setFrame:BUTTON_FRAME];
    [shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    return shareBarButtonItem;
}


-(UIBarButtonItem *)flexSpaceButton {
    UIBarButtonItem *flexibleSpaceBarButtonItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    return flexibleSpaceBarButtonItem;
}

-(UIBarButtonItem *)doneButton {
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.tintColor = [UIColor MUSGreenMachine];
//    UIImage *doneButtonImage = [UIImage imageNamed:@"save" withColor:[UIColor MUSGreenMachine]];
    UIImage *doneButtonImage = [UIImage imageNamed:@"save"];
    [doneButton setImage:doneButtonImage forState:UIControlStateNormal];
    [doneButton setFrame:BUTTON_FRAME];
    [doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];

    return doneBarButtonItem;
}





#pragma mark - Button Actions

-(void)moreOptionsButtonPressed {
    [self.delegate didSelectMoreOptionsButton];
}

-(void)seePlaylistButtonPressed:(id)sender {
    NSLog(@"seePlaylistButtonPressed");
    [self.delegate didSelectPlaylistButton:sender];
}

-(void)titleButtonPressed:(id)sender {
    NSLog(@"titleButtonPressed");
    [self.delegate didSelectTitleButton:sender];
}

-(void)doneButtonPressed:(id)sender{
    NSLog(@"doneButtonPressed");
    [self.delegate didSelectDoneButton:sender];;
}

-(void)backButtonPressed:(id)sender {
    [self.delegate didSelectBackButton:sender];
}

-(void)shareButtonPressed:(id)sender {
    [self.delegate didSelectShareButton:sender];
}

-(void)pickSongButtonPressed:(id)sender {
    [self.delegate didPickSongButtonPressed:sender];
}

-(void)pinSongButtonPressed:(id)sender {
    NSLog(@"pinSongButtonPressed");
    [self.delegate didSelectAddSongButton:sender];
}

#pragma mark - Button Pressed methods
-(void)cameraButtonPressed{
    NSLog(@"cameraButtonPressed");
    [self.delegate didSelectCameraButton];
}
@end
