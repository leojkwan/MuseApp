//
//  MUSTimelineUIManager.h
//  Muse
//
//  Created by Leo Kwan on 10/15/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PromptDelegate <NSObject>
-(void)newEntryFromPrompt;
@end



@interface MUSTimelineUIManager : NSObject

@property (nonatomic, assign) id <PromptDelegate> delegate;
+(UILabel *)returnSectionLabelWithFrame:(CGRect)frame fontColor:(UIColor*)color backgroundColor:(UIColor *)bgColor;
-(UIImageView *) returnMuseImagePromptForView:(UIView*)view;
-(UILabel *) returnMuseLabelPromptForView:(UIView*)view imageView:(UIImageView *)promptImageView;


@end
