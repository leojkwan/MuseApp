//
//  MUSKeyboardTopBar.m
//  MuseApp
//


#import "MUSKeyboardTopBar.h"
#import <Masonry.h>
#import "UIButton+ExtraMethods.h"
#import "UIImageView+ExtraMethods.h"
#import "UIImage+ExtraMethods.h"

#define BUTTON_FRAME CGRectMake (0, 0, 50, 50)
#define BUTTON_COLOR [UIColor darkGrayColor]



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

-(void)commonInit {
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
    self.toolbarButtonItems = [[NSMutableArray alloc] init];
    
    // set up bar buttons items in this order left to right
    
    [self.toolbarButtonItems addObject:[self backButton]];
    [self.toolbarButtonItems addObject:[self flexSpaceButton]];
    [self.toolbarButtonItems addObject:[self cameraButton]];
    [self.toolbarButtonItems addObject:[self flexSpaceButton]];
    [self.toolbarButtonItems addObject:[self pinSongButton]];
    [self.toolbarButtonItems addObject:[self flexSpaceButton]];
    [self.toolbarButtonItems addObject:[self playlistButton]];
    
    
    // after all buttons have been set... set array to toolbar
    [self.keyboardToolBar setItems:self.toolbarButtonItems animated:YES];
}

-(void)setUpKeyboardButtons {
    self.keyboardButtonItems = [[NSMutableArray alloc] init];
    // set up bar buttons items in this order left to right
    [self.keyboardButtonItems addObject:[self makeTitleButton]];
    [self.keyboardButtonItems addObject:[self fixedSpaceButtonOfWidth:15]];
    [self.keyboardButtonItems addObject:[self cameraButton]];
    [self.keyboardButtonItems addObject:[self fixedSpaceButtonOfWidth:15]];
    [self.keyboardButtonItems addObject:[self pinSongButton]];
    [self.keyboardButtonItems addObject:[self fixedSpaceButtonOfWidth:15]];
    [self.keyboardButtonItems addObject:[self playlistButton]];
    [self.keyboardButtonItems addObject:[self flexSpaceButton]];
    [self.keyboardButtonItems addObject:[self doneButton]];
    
    
    // after all buttons have been set... set array to toolbar
    [self.keyboardToolBar setItems:self.keyboardButtonItems animated:YES];
    
}


#pragma mark - Create Buttons

-(UIBarButtonItem *)makeTitleButton {
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 25)];
    titleView.image = [UIImage imageNamed:@"title"];
    [titleView setImageToColorTint:BUTTON_COLOR];
    titleView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleButtonPressed:)];
    [titleView addGestureRecognizer:titleTap];
    UIBarButtonItem *titleBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:titleView];
    return titleBarButtonItem;
}


-(UIBarButtonItem *)cameraButton {
    
    UIImageView *coolCameraImageView = [[UIImageView alloc] initWithFrame:BUTTON_FRAME];

    coolCameraImageView.image = [UIImage imageNamed:@"addImage"];
    [coolCameraImageView setImageToColorTint:BUTTON_COLOR];
    coolCameraImageView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *cameraTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraButtonPressed)];
    [coolCameraImageView addGestureRecognizer:cameraTap];
    UIBarButtonItem *coolCameraBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:coolCameraImageView];
    self.cameraBarButtonItem = coolCameraBarButtonItem;
    return coolCameraBarButtonItem;
}

-(UIBarButtonItem *)backButton {

    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    backImageView.image = [UIImage imageNamed:@"back"];
    [backImageView setImageToColorTint:BUTTON_COLOR];
    backImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonPressed:)];
    [backImageView addGestureRecognizer:backTap];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: backImageView];
    return backBarButtonItem;
}



-(UIBarButtonItem *)playlistButton {


    
    UIImageView *playlistView = [[UIImageView alloc] initWithFrame:BUTTON_FRAME];
    playlistView.image = [UIImage imageNamed:@"playlist"];
    [playlistView setImageToColorTint:[UIColor blackColor]];
    
    
    UIImageView *playlistView2 = [[UIImageView alloc] initWithFrame:BUTTON_FRAME];
    playlistView2.image = [UIImage imageNamed:@"playlist"];
//    [playlistView2 setImageToColorTint:[UIColor yellowColor]];

    
    playlistView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIButton *playlistButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playlistButton setImage:[UIImage imageNamed:@"musicPlayer" withColor:BUTTON_COLOR] forState:UIControlStateNormal];
    [playlistButton setImage:playlistView2.image forState:UIControlStateSelected];

    
    
//    [playlistButton addSubview:playlistView];
    [playlistButton setFrame:BUTTON_FRAME];

    [playlistButton addTarget:self action:@selector(seePlaylistButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *playlistBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:playlistButton];
    return playlistBarButtonItem;
}

-(UIBarButtonItem *)pinSongButton {
    UIImageView *pinSongView = [[UIImageView alloc] initWithFrame:BUTTON_FRAME];
    pinSongView.image = [UIImage imageNamed:@"pinSong"];
    [pinSongView setImageToColorTint:BUTTON_COLOR];
    pinSongView.contentMode = UIViewContentModeScaleAspectFit;
    
    UITapGestureRecognizer *pinTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pinSongButtonPressed:)];
    [pinSongView addGestureRecognizer:pinTap];
    
    UIBarButtonItem *pinSongButtonItem = [[UIBarButtonItem alloc] initWithCustomView:pinSongView];
    
    return pinSongButtonItem;
}


-(UIBarButtonItem *)flexSpaceButton {
    UIBarButtonItem *flexibleSpaceBarButtonItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    return flexibleSpaceBarButtonItem;
}

-(UIBarButtonItem *)fixedSpaceButtonOfWidth:(CGFloat)width {
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = width;
    return fixedSpaceBarButtonItem;
}

-(UIBarButtonItem *)doneButton {
    
    // set up done bar button
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:@selector(doneButtonPressed:)];
    return doneBarButtonItem;
}





#pragma mark - Button Actions


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
