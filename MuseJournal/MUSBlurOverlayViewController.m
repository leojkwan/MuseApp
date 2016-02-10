#import "MUSBlurOverlayViewController.h"

@interface MUSBlurOverlayViewController ()
@end

@implementation MUSBlurOverlayViewController

-(instancetype)initWithView:(UIView *)viewOverBlur blurEffect:(UIVisualEffect*)effect {
    self = [super init];
    
    if (self) {
        _viewOverBlur = viewOverBlur;
        _blurType = effect;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // Create Blur View, add to subview, cover entire frame.
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:self.blurType];
    [self.view addSubview:visualEffectView];
    visualEffectView.frame = self.view.bounds;
    
    // add content over blur
    [visualEffectView addSubview:self.viewOverBlur];
    self.viewOverBlur.frame = visualEffectView.bounds;
}

#pragma mark-Blur View Methods

-(void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
