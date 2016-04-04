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

-(void)loadPlaylistArtworkForThisEntryWithCompletionBlock:(void (^)(NSMutableArray *))block;
-(void)checkIfSongIsInLocalLibrary:(Song *)song withCompletionBlock:(void (^) (BOOL)) completionBlock;
-(void)returnRandomSongInLibraryWithCompletionBlock:(void (^)(MPMediaItemCollection *))block;
-(void)loadMPCollectionFromFormattedMusicPlaylist:(NSArray *)playlist completionBlock:(void (^)(MPMediaItemCollection *))block;

@end
