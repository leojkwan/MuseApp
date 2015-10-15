//
//  MUSKeyboardTopBar.h
//  MuseApp
//
//  Created by Leo Kwan on 8/26/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MUSKeyboardInputDelegate <NSObject>

-(void)didSelectCameraButton;
-(void)didSelectDoneButton:(id)sender;
-(void)didSelectPlaylistButton:(id)sender;
-(void)didSelectAddSongButton:(id)sender;
-(void)didSelectBackButton:(id)sender;
-(void)didSelectTitleButton:(id)sender;

@end

@interface MUSKeyboardTopBar : UIView

@property (nonatomic, assign) id<MUSKeyboardInputDelegate> delegate;
@property (strong, nonatomic) UIBarButtonItem *cameraBarButtonItem;
@property (strong, nonatomic) UIColor *backgroundColor;
-(instancetype)initWithToolbarWithBackgroundColor:color;
-(instancetype)initWithKeyboardWithBackgroundColor:color;

@end
