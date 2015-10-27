//
//  MUSDetailEntryViewController.h
//  MuseApp
//
//  Created by Leo Kwan on 8/23/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"

typedef enum{
    Playing,
    NotPlaying,
    Invalid,
    AlreadyPinned
}PlayerStatus;

typedef enum{
    NewEntry,
    RandomSong,
    ExistingEntry
} EntryType;

typedef enum {
    autoplayOFF,
    autoplayON
} AutoPlay;

@protocol MUSNotificationDelegate
-(void)displayNotificationForSongName:(NSString *)title;
@end

@interface MUSDetailEntryViewController : UIViewController
@property (nonatomic, strong) Entry *destinationEntry;
@property (nonatomic, assign) id <MUSNotificationDelegate> delegate;
@property (nonatomic, assign) EntryType entryType;
//@property (nonatomic, strong) MUSMusicPlayer *musicPlayer;


@end
