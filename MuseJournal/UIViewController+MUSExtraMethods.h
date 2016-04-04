#import <UIKit/UIKit.h>

@interface UIViewController (MUSExtraMethods)

-(void)presentViewController:(UIViewController *)dvc withView:(UIView *)viewOverBlur;

-(void)animateCell:(UITableViewCell*)cell;

@end
