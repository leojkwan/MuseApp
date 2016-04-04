//
//  MUSEntryToolbar.h
//  MuseApp

#import <UIKit/UIKit.h>

@protocol MUSEntryToolbarDelegate <NSObject>
-(void)didSelectAddButton:(id)sender;
-(void)didSelectWallpaperButton:(id)sender;

@end


@interface MUSEntryToolbar : UIView

@property (nonatomic, assign) id<MUSEntryToolbarDelegate> delegate;



@end
