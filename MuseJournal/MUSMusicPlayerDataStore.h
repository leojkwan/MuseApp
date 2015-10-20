//
//  MUSMusicPlayerDataStore.h
//  Muse
//
//  Created by Leo Kwan on 10/19/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MUSMusicPlayer.h"

@interface MUSMusicPlayerDataStore : NSObject


+ (instancetype)sharedMusicPlayerDataStore;
@property(nonatomic, strong) MUSMusicPlayer *musicPlayer;

@end

