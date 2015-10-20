//
//  MUSActionView.m
//  MuseApp
//
//  Created by Leo Kwan on 9/24/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSActionView.h"
#import <Masonry/Masonry.h>
#import "MUSWallpaperManager.h"

@interface MUSActionView ()
@property (strong, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIButton *randomSongButton;
@property (weak, nonatomic) IBOutlet UIButton *addEntryButton;


@end


@implementation MUSActionView

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

-(void)commonInit
{
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class)
                                  owner:self
                                options:nil];
    
    [self addSubview:self.actionView];
    
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];

    
    //ADD OBSERVER TO LISTEN FOR WALLPAPER CHANGES
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configureTextLabelColor) name:@"updateBackground" object:nil];

    // CONFIGURE TEXT COLOR
    [self configureTextLabelColor];
    
}

-(void)configureTextLabelColor {
    NSInteger userWallpaperPreference = [[NSUserDefaults standardUserDefaults] integerForKey:@"background"]; // this is an NSINTEGER
    self.textLabel1.textColor = [MUSWallpaperManager returnTextColorForWallpaperIndex:userWallpaperPreference];
    self.textLabel2.textColor = [MUSWallpaperManager returnTextColorForWallpaperIndex:userWallpaperPreference];
}



- (IBAction)addButtonTapped:(id)sender {
    [self.delegate didSelectAddButton:self];
}

- (IBAction)shuffleButtonTapped:(id)sender {
    [self.delegate didSelectShuffleButton:self];
}




@end
