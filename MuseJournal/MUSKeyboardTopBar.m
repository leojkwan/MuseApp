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
#define BUTTON_COLOR [UIColor colorWithRed:0.78 green:0.62 blue:0.75 alpha:1]

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
  
    UIButton *markDownTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [markDownTitleButton setImage:[UIImage imageNamed:@"title" withColor:BUTTON_COLOR] forState:UIControlStateNormal];
    [markDownTitleButton setFrame:CGRectMake(0, 0, 35, 35)];
    [markDownTitleButton addTarget:self action:@selector(titleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *titleBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:markDownTitleButton];
    return titleBarButtonItem;
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

-(UIBarButtonItem *)pinSongButton {
    
    UIButton *pinSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pinSongButton setImage:[UIImage imageNamed:@"pinSong" withColor:BUTTON_COLOR] forState:UIControlStateNormal];
    [pinSongButton setFrame:BUTTON_FRAME];
    [pinSongButton addTarget:self action:@selector(pinSongButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *pinSongButtonItem = [[UIBarButtonItem alloc] initWithCustomView:pinSongButton];
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
