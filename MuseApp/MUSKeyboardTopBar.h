//
//  MUSKeyboardTopBar.h
//  MuseApp
//
//  Created by Leo Kwan on 8/26/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUSKeyboardInputDelegate <NSObject>

-(void)didSelectCameraButton:(id)sender;

@end

@interface MUSKeyboardTopBar : UIView

@property (nonatomic, assign) id<MUSKeyboardInputDelegate> delegate;
@property (nonatomic, strong) UIBarButtonItem *cameraBarButtonItem;


@end
