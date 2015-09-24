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
#import "UIImage+MUSExtraMethods.h"

@interface MUSEntryToolbar ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) NSMutableArray *toolbarButtonItems;
@property (weak, nonatomic) IBOutlet UIButton *addEntryButton;

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


-(void)addButtonPressed:(id)sender {
    [self.delegate didSelectAddButton:sender];
}




@end
