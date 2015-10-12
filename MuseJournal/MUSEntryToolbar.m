//
//  MUSEntryToolbar.m
//  MuseApp
//
//  Created by Leo Kwan on 9/23/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSEntryToolbar.h"
#import <Masonry.h>
#import "UIButton+ExtraMethods.h"
#import "UIImageView+ExtraMethods.h"
#import "NSAttributedString+MUSExtraMethods.h"


@interface MUSEntryToolbar ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) NSMutableArray *toolbarButtonItems;
@property (weak, nonatomic) IBOutlet UIButton *addEntryButton;
@property (nonatomic, assign) AutoPlay autoplayStatus;
@property (weak, nonatomic) IBOutlet UILabel *autoPlayLabel;

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
    
    [self.autoPlayButton addTarget:self action:@selector(autoPlayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}



-(void)autoPlayButtonPressed:(id)sender {
    [self.delegate didSelectAutoPlayButton:sender];
    
    NSLog(@"tap autoplay");
    
    BOOL autoplayStatus = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoplay"];
    
    if (autoplayStatus) { // if on, toggle off
        [self.autoPlayButton setAttributedTitle:[NSAttributedString returnAutoPlayButtonText:NO] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoplay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.autoplayStatus = autoplayOFF;
    }   else { // if off, toggle on
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoplay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.autoplayStatus = autoplayON;
        [self.autoPlayButton setAttributedTitle:[NSAttributedString returnAutoPlayButtonText:YES] forState:UIControlStateNormal];
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
    BOOL autoplayStatus = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoplay"];
    [self.autoPlayButton setAttributedTitle:[NSAttributedString returnAutoPlayButtonText:autoplayStatus] forState:UIControlStateNormal];
    
    if (autoplayStatus)
        self.autoplayStatus = autoplayON;
    else
        self.autoplayStatus = autoplayOFF;
}




@end
