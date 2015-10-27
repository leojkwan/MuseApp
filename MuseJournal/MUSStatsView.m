//
//  MUSStatsView.m
//  Muse
//
//  Created by Leo Kwan on 10/21/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSStatsView.h"

@interface MUSStatsView ()
@property (strong, nonatomic) IBOutlet UIView *actionView;




@end

@implementation MUSStatsView

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
//    [self configureTextLabelColor];

}

-(void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow == nil) {
        // unsubscribe from any notifications here
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateBackground" object:nil];
    }
}

-(void)configureTextLabelColor {
//    NSInteger userWallpaperPreference = [[NSUserDefaults standardUserDefaults] integerForKey:@"background"]; // this is an NSINTEGER
//    self.textLabel1.textColor = [MUSWallpaperManager returnTextColorForWallpaperIndex:userWallpaperPreference];
//    self.textLabel2.textColor = [MUSWallpaperManager returnTextColorForWallpaperIndex:userWallpaperPreference];
}


@end
