//
//  MUSEntryToolbar.m
//  MuseApp

#import "MUSEntryToolbar.h"
#import <Masonry.h>
#import "UIButton+ExtraMethods.h"
#import "UIImageView+ExtraMethods.h"
#import "NSAttributedString+MUSExtraMethods.h"
#import "MUSAutoPlayManager.h"
#import "MUSDetailEntryViewController.h"
#import "UIImage+ExtraMethods.h"

@interface MUSEntryToolbar ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) NSMutableArray *toolbarButtonItems;
@property (weak, nonatomic) IBOutlet UIButton *addEntryButton;
@property (nonatomic, assign) AutoPlay autoplayStatus;
@property (weak, nonatomic) IBOutlet UILabel *autoPlayLabel;
@property (weak, nonatomic) IBOutlet UISwitch *autoplaySwitch;
@property (weak, nonatomic) IBOutlet UIButton *selectWallpaperButton;

@end

@implementation MUSEntryToolbar


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


-(void)commonInit {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class)
                                  owner:self
                                options:nil];
    
    // Set up autoplay
    [self setUpAutoPlayButton];
    
    // Tap Gesture for Autoplay Label
    [self setUpTapGestureForAutoPlayLabel];
    
    // remove hairline
    self.clipsToBounds = YES;
    
    // add content view to xib
    [self addSubview:self.contentView];
    
    // add button action
    [self.addEntryButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

- (IBAction)switchTapped:(id)sender {
    
    if([sender isOn]){
        NSLog(@"Switch is ON");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoplay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else{
        NSLog(@"Switch is OFF");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoplay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)selectWallpaperButtonPressed:(id)sender {
  [self.delegate didSelectWallpaperButton:sender];
}

-(void)autoPlayButtonPressed:(id)sender {
    
    if ([MUSAutoPlayManager returnAutoPlayStatus]) { // if on, toggle off
        self.autoplayStatus = autoplayOFF;
    }   else { // if off, toggle on
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoplay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.autoplayStatus = autoplayON;
    }
}

-(void)setUpTapGestureForAutoPlayLabel {
    UITapGestureRecognizer *autoplay = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(autoPlayButtonPressed:)];
    [self.autoPlayLabel addGestureRecognizer:autoplay];
    self.autoPlayLabel.userInteractionEnabled = YES;
}

-(void)addButtonPressed:(id)sender {
    [self.delegate didSelectAddButton:sender];
}

-(void)setUpAutoPlayButton {
    [self.autoplaySwitch setOn:[MUSAutoPlayManager returnAutoPlayStatus] animated:YES];
}

@end
