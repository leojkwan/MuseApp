//
//  EntryWalkthroughView.h
//  Muse
//
//  Created by Leo Kwan on 11/22/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WalkthroughDelegate <NSObject>
-(void)didSelectDoneButton;
@end

@interface EntryWalkthroughView : UIView
@property (nonatomic, assign) id <WalkthroughDelegate> delegate;

@end
