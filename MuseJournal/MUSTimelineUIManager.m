//
//  MUSTimelineUIManager.m
//  Muse
//
//  Created by Leo Kwan on 10/15/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSTimelineUIManager.h"
#import <Masonry.h>


@implementation MUSTimelineUIManager

+(UILabel *)returnSectionLabelWithFrame:(CGRect)sectionFrame fontColor:(UIColor*)color backgroundColor:(UIColor *)bgColor {
    UILabel *sectionLabel = [[UILabel alloc] init];
    sectionLabel.frame = sectionFrame;
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    [sectionLabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:13.0]];
    sectionLabel.textColor = color;
    sectionLabel.backgroundColor = bgColor;
    return sectionLabel;
}

-(UIImageView *) returnMuseImagePromptForView:(UIView*)view {
    
    UIImageView *promptView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MUSIcon"]];
    [view addSubview:promptView];
    [promptView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.width.equalTo(view).dividedBy(4);
        make.height.equalTo(promptView.mas_width);
    }];
    
    // ADD GESTURE RECOGNIZER
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(promptTapped)];
    [promptView addGestureRecognizer:tap];
    [promptView setUserInteractionEnabled:YES];
    return promptView;
}

-(UILabel *) returnMuseLabelPromptForView:(UIView*)view imageView:(UIImageView *)promptImageView {
    UILabel *musePromptLabel = [[UILabel alloc] init];
    musePromptLabel.text = @"Begin a new story!";
    musePromptLabel.numberOfLines = 0;
    musePromptLabel.textAlignment = NSTextAlignmentCenter;
    musePromptLabel.font = [UIFont fontWithName:@"ADAM.CGPRO" size:20.0];
    musePromptLabel.textColor = [UIColor whiteColor];
    
    [view addSubview:musePromptLabel];
    [musePromptLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptImageView.mas_bottom).with.offset(0);
        make.centerX.equalTo(view.mas_centerX);
        make.width.equalTo(view).dividedBy(2);
    }];
    
        // ADD GESTURE RECOGNIZER
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(promptTapped)];
    [musePromptLabel addGestureRecognizer:tap];
    [musePromptLabel setUserInteractionEnabled:YES];
    return musePromptLabel;
}

-(void)promptTapped {
    [self.delegate newEntryFromPrompt];
}

@end
