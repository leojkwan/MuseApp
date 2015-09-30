//
//  MUSKeyboardTopBar.m
//  MuseApp
//


#import "MUSKeyboardTopBar.h"
#import <Masonry.h>
#import "UIButton+ExtraMethods.h"
#import "UIImage+MUSExtraMethods.h"

#define BUTTON_FRAME CGRectMake (0, 0, 40, 40)


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
    UIButton* makeTitleButton = [[UIButton alloc] initWithFrame:CGRectMake (0, 0, 35, 25)];
    [makeTitleButton addTarget:self action:@selector(titleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [makeTitleButton setBackgroundImage:[UIImage imageNamed:@"title"] forState:UIControlStateNormal];
    
    UIBarButtonItem *makeTitleBarButtonItem = [[UIBarButtonItem alloc]  initWithCustomView:makeTitleButton];
    return makeTitleBarButtonItem;
}


-(UIBarButtonItem *)cameraButton {
    UIButton* cameraButton = [[UIButton alloc] initWithFrame:BUTTON_FRAME];
    [cameraButton addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    
    UIBarButtonItem *cameraBarButtonItem = [[UIBarButtonItem alloc]  initWithCustomView:cameraButton];
    return cameraBarButtonItem;
}

-(UIBarButtonItem *)backButton {
    UIButton* backButton = [[UIButton alloc] initWithFrame:BUTTON_FRAME];
    [backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc]  initWithCustomView:backButton];
    return backBarButtonItem;
}



-(UIBarButtonItem *)playlistButton {
    UIButton* seePlaylistButton = [[UIButton alloc] initWithFrame:BUTTON_FRAME];
    [seePlaylistButton addTarget:self action:@selector(seePlaylistButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [seePlaylistButton setBackgroundImage:[UIImage imageNamed:@"playlist"] forState:UIControlStateNormal];
    
    // set up camera bar button
    UIBarButtonItem *seePlaylistBarButtonItem = [[UIBarButtonItem alloc]  initWithCustomView:seePlaylistButton];
    return seePlaylistBarButtonItem;
}

-(UIBarButtonItem *)pinSongButton {

    UIButton* addSongButton = [[UIButton alloc] initWithFrame:BUTTON_FRAME];
     [addSongButton addTarget:self action:@selector(pinSongButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [addSongButton setBackgroundImage:[UIImage imageNamed:@"addToPlaylist"] forState:UIControlStateNormal];
    
    UIBarButtonItem *addSongBarButtonItem = [[UIBarButtonItem alloc]  initWithCustomView:addSongButton];
    return addSongBarButtonItem;
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
-(void)cameraButtonPressed:(id)sender{
    NSLog(@"cameraButtonPressed");
    [self.delegate didSelectCameraButton:sender];
}
@end
