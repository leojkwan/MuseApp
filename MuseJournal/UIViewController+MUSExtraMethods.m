
#import "UIViewController+MUSExtraMethods.h"
#import "MUSBlurOverlayViewController.h"
#import <Masonry/Masonry.h>

@implementation UIViewController (MUSExtraMethods)

-(void)presentViewController:(UIViewController *)dvc withView:(UIView *)viewOverBlur {
    
    // Set modal to lay over stack
    dvc.modalPresentationStyle = UIModalPresentationOverFullScreen;

    
    // Dark Blur
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.view.bounds;
    
    // Add over main view
    [dvc.view addSubview:visualEffectView];
    
    // add content over blur
    [visualEffectView addSubview:viewOverBlur];
    viewOverBlur.frame = visualEffectView.bounds;
    
    [self presentViewController:dvc animated:YES completion:nil];
}

-(void)animateCell:(UITableViewCell*)cell {
  
  CGRect frame = cell.contentView.frame;
  cell.contentView.frame = frame;
  cell.contentView.alpha = .2;
  
  
  [UIView animateWithDuration:0.15 animations:^() {
    CGRect frame = cell.contentView.frame;
    cell.contentView.frame = frame;
    cell.contentView.alpha = 1;
    
  } completion: nil];
  
}


@end
