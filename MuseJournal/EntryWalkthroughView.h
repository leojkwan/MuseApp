/**
 * Quick entry walkthrough for users
 * writing an entry for the first time.
 */

#import <UIKit/UIKit.h>

@protocol WalkthroughDelegate <NSObject>
-(void)dismissView;
@end

@interface EntryWalkthroughView : UIView
@property (nonatomic, assign) id <WalkthroughDelegate> delegate;

@end
