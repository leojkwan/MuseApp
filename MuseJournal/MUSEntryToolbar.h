//
//  MUSEntryToolbar.h
//  MuseApp
//
//  Created by Leo Kwan on 9/23/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUSEntryToolbarDelegate <NSObject>
-(void)didSelectAddButton:(id)sender;
-(void)didSelectAutoPlayButton:(id)sender;
@end


@interface MUSEntryToolbar : UIView

@property (nonatomic, assign) id<MUSEntryToolbarDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *autoPlayButton;



@end
