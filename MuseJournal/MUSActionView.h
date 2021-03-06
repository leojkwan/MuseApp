//
//  MUSActionView.h
//  MuseApp
//
//  Created by Leo Kwan on 9/24/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

@protocol ActionViewDelegate <NSObject>

-(void)didSelectAddButton:(id)sender;
-(void)didSelectShuffleButton:(id)sender;

@end

@interface MUSActionView : UIView

@property (weak, nonatomic) IBOutlet UILabel *textLabel1;
@property (weak, nonatomic) IBOutlet UILabel *textLabel2;
@property  (nonatomic, assign) id <ActionViewDelegate> delegate;

@end
