
/**
 * Blur View Controller with a convenience initializer
 * so pass custom UIView on top of blur
 */

#import <UIKit/UIKit.h>
#import "EntryWalkthroughView.h"

@interface MUSBlurOverlayViewController : UIViewController <WalkthroughDelegate>

@property (nonatomic, strong) UIView *viewOverBlur;
@property (nonatomic, strong) UIVisualEffect *blurType;

-(instancetype)initWithView:(UIView *)viewOverBlur blurEffect:(UIVisualEffect*)effect;

@end
