
#import "UIViewController+MUSExtraMethods.h"
#import <Masonry/Masonry.h>

@implementation UIViewController (MUSExtraMethods)

-(void)presentBlurModalWithView:(UIView *)viewOverBlur {

    // Set modal to lay over stack
    UIViewController *modalBlurVC= [[UIViewController alloc] init];
    modalBlurVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    // Dark Blur
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.view.bounds;
    
    // Add over main view
    [self.view addSubview:visualEffectView];
    
    // add content over blur
    [visualEffectView addSubview:viewOverBlur];
    viewOverBlur.frame = visualEffectView.bounds;
    
    [self presentViewController:modalBlurVC animated:YES completion:nil];
}

@end
