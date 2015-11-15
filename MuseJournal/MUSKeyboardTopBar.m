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
#define BUTTON_COLOR [UIColor darkGrayColor] //COLOR OF BAR BUTTON ITEMS

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
    [self.toolbarButtonItems addObject:[self createButtonWithImage:[UIImage imageNamed:@"back"] action:@selector(backButtonPressed:) frame:CGRectMake(0, 0, 30, 30)]];
    [self.toolbarButtonItems addObject:[self flexSpaceButton]];
    [self.toolbarButtonItems addObject:[self createButtonWithImage:[UIImage imageNamed:@"searchSong"] action:@selector(pickSongButtonPressed:) frame:BUTTON_FRAME]];
    [self.toolbarButtonItems addObject:[self flexSpaceButton]];
    [self.toolbarButtonItems addObject:[self createButtonWithImage:[UIImage imageNamed:@"pinSong"] action:@selector(pinSongButtonPressed:) frame:BUTTON_FRAME]];
    [self.toolbarButtonItems addObject:[self flexSpaceButton]];
    [self.toolbarButtonItems addObject:[self createButtonWithImage:[UIImage imageNamed:@"musicPlayer"] action:@selector(seePlaylistButtonPressed:) frame:BUTTON_FRAME]];
    [self.toolbarButtonItems addObject:[self flexSpaceButton]];
    [self.toolbarButtonItems addObject:[self createButtonWithImage:[UIImage imageNamed:@"moreOptions"] action:@selector(moreOptionsButtonPressed) frame:BUTTON_FRAME]];

    // SET BACKGROUND COLOR
    self.keyboardToolBar.barTintColor =color;
    
    // after all buttons have been set... set array to toolbar
    [self.keyboardToolBar setItems:self.toolbarButtonItems animated:YES];
}

-(void)setUpKeyboardButtonsWithBackgroundColor:color  {
    
    self.keyboardButtonItems = [[NSMutableArray alloc] init];
    
    // set up bar buttons items in this order left to right
    [self.keyboardButtonItems addObject:[self createButtonWithImage:[UIImage imageNamed:@"title"] action:@selector(titleButtonPressed:) frame:CGRectMake(0, 0, 35, 35)]];
    [self.keyboardButtonItems addObject:[self createButtonWithImage:[UIImage imageNamed:@"addImage"] action:@selector(cameraButtonPressed) frame:BUTTON_FRAME]];
    [self.keyboardButtonItems addObject:[self createButtonWithImage:[UIImage imageNamed:@"searchSong"] action:@selector(pickSongButtonPressed:) frame:BUTTON_FRAME]];
    [self.keyboardButtonItems addObject:[self createButtonWithImage:[UIImage imageNamed:@"pinSong"] action:@selector(pinSongButtonPressed:) frame:BUTTON_FRAME]];
    [self.keyboardButtonItems addObject:[self createButtonWithImage:[UIImage imageNamed:@"musicPlayer"] action:@selector(seePlaylistButtonPressed:) frame:BUTTON_FRAME]];
    [self.keyboardButtonItems addObject:[self flexSpaceButton]];
    [self.keyboardButtonItems addObject:[self createButtonWithImage:[UIImage imageNamed:@"save"] action:@selector(doneButtonPressed:) frame:BUTTON_FRAME]];
    
    // SET BACKGROUND COLOR
    self.keyboardToolBar.barTintColor =color;
    
    // after all buttons have been set... set array to toolbar
    [self.keyboardToolBar setItems:self.keyboardButtonItems animated:YES];
}


#pragma mark - Create Buttons

-(UIBarButtonItem *)flexSpaceButton {
    UIBarButtonItem *flexibleSpaceBarButtonItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    return flexibleSpaceBarButtonItem;
}

-(UIBarButtonItem *)createButtonWithImage:(UIImage *)image action:(SEL)action frame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tintColor = BUTTON_COLOR;
    UIImage *doneButtonImage = image;
    [button setImage:doneButtonImage forState:UIControlStateNormal];
    [button setFrame:frame];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

#pragma mark - Button Actions

-(void)moreOptionsButtonPressed {
    [self.delegate didSelectMoreOptionsButton];
}

-(void)seePlaylistButtonPressed:(id)sender {;
    [self.delegate didSelectPlaylistButton:sender];
}

-(void)titleButtonPressed:(id)sender {
    [self.delegate didSelectTitleButton:sender];
}

-(void)doneButtonPressed:(id)sender{
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
    [self.delegate didSelectAddSongButton:sender];
}

#pragma mark - Button Pressed methods
-(void)cameraButtonPressed{
    [self.delegate didSelectCameraButton];
}
@end
