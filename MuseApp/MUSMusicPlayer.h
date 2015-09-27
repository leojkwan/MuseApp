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



-(instancetype)init;
-(void *)loadMPCollectionFromFormattedMusicPlaylist:(NSArray *)playlist withCompletionBlock:(void (^)(MPMediaItemCollection *))block;
-(void)loadPlaylistArtworkForThisEntryWithCompletionBlock:(void (^)(NSMutableArray *))block;
-(void)checkIfSongIsInLocalLibrary:(MPMediaEntityPersistentID)persistentID withCompletionBlock:(void (^) (BOOL)) completionBlock;
-(void)returnRandomSongInLibraryWithCompletionBlock:(void (^)(MPMediaItemCollection *))block;

@end
