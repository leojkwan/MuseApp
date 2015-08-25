//
//  MUSMusicPlayer.h
//  MuseApp
//
//  Created by Leo Kwan on 8/24/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Song.h"

@import MediaPlayer;


@interface MUSMusicPlayer : NSObject

@property (nonatomic, strong) MPMusicPlayerController *myPlayer;
@property (nonatomic, strong) MPMediaItem *currentlyPlayingSong;


-(instancetype)init;
-(void *)loadMPCollectionFromFormattedMusicPlaylist:(NSMutableArray *)playlist withCompletionBlock:(void (^)(MPMediaItemCollection *))block;

-(void)removeMusicNotifications;



@end