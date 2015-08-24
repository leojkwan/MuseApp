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


@protocol MUSPlayerProtocol<NSObject>
-(void)getCurrentlyPlayingSong:(Song *)song;
@optional

@end

@interface MUSMusicPlayer : NSObject

@property (nonatomic, strong) MPMusicPlayerController *myPlayer;
@property (nonatomic, assign) id <MUSPlayerProtocol> delegate;


-(instancetype)init;
-(NSMutableArray *)loadMPMediaItemsFromPlaylist:(NSArray *)playlist;
-(void)removeMusicNotifications;
-(Song * )pinCurrentlyPlayingSong;



@end
