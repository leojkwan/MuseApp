//
//  MUSEntryToobar.m
//  
//
//  Created by Leo Kwan on 9/23/15.
//
//

#import "MUSEntryToolbar.h"
#import <Masonry.h>
#import "UIButton+ExtraMethods.h"
#import "UIImage+MUSExtraMethods.h"

#define BUTTON_FRAME CGRectMake (0, 0, 40, 40)

@interface MUSEntryToolbar ()


@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIToolbar *entryToolBar;
@property (nonatomic, strong) NSMutableArray *toolbarButtonItems;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addEntryBarButtonItem;

@end

@implementation MUSEntryToobar

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



#pragma mark - Create Buttons

@end
