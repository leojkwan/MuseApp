//
//  MUSMusicPlayer.m
//  MuseApp
//
//  Created by Leo Kwan on 8/24/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "MUSMusicPlayer.h"
#import "MUSDataStore.h"

@interface MUSMusicPlayer ()

@property (nonatomic, strong) NSNotificationCenter *currentMusicPlayingNotifications;
@property (nonatomic, strong) NSMutableArray *playlistCollection;
@property (nonatomic, strong) MUSDataStore *store;
@end

@implementation MUSMusicPlayer

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        _myPlayer = [[MPMusicPlayerController  alloc] init];
    }
    return self;
}

-(void)loadPlaylistArtworkForThisEntryWithCompletionBlock:(void (^)(NSMutableArray *))block {
    NSMutableArray *arrayOfSongImages = [[NSMutableArray alloc] init];
    for (MPMediaItem *song in self.playlistCollection) {
        UIImage *artworkForThisSong = [song.artwork imageWithSize:CGSizeMake(200, 200)];
        if (artworkForThisSong != nil) {
            [arrayOfSongImages addObject:artworkForThisSong];
        } else {
            [arrayOfSongImages addObject:[UIImage imageNamed:@"addImage"]];
        }
    }
    block(arrayOfSongImages);
}


-(void *)loadMPCollectionFromFormattedMusicPlaylist:(NSArray *)playlist withCompletionBlock:(void (^)(MPMediaItemCollection *))block {
    
    self.playlistCollection = [[NSMutableArray alloc] init];
    
    if (playlist.count > 0) {
        
        for (Song *song in playlist) {
            
            MPMediaPropertyPredicate *persistentIDPredicate =
            [MPMediaPropertyPredicate predicateWithValue:song.persistentID
                                             forProperty:MPMediaItemPropertyPersistentID];

            MPMediaQuery *songAndArtistQuery = [ [MPMediaQuery alloc] init];
            [songAndArtistQuery addFilterPredicate:persistentIDPredicate];
            
            // Store the queried MPMediaItems in an NSArray
            NSArray *resultingMediaItemFromQuery  = [songAndArtistQuery items];
            
            // add MPMediaItems into MPMediaCollection
            [self.playlistCollection addObjectsFromArray:resultingMediaItemFromQuery];
        }
        // at this point I have an array full of the media items that I want, which is playlist collection
        
        MPMediaItemCollection *currentPlaylistCollection = [MPMediaItemCollection collectionWithItems:self.playlistCollection];
        
        block(currentPlaylistCollection);
    }
    //else
    return nil;
}


-(void)returnRandomSongInLibraryWithCompletionBlock:(void (^)(MPMediaItemCollection *))block {
    MPMediaQuery *allSongsQuery = [ [MPMediaQuery alloc] init];
    NSArray *resultingMediaItemFromQuery = [allSongsQuery items];
    NSUInteger randomNumberInSongCount = arc4random_uniform((uint32_t) [resultingMediaItemFromQuery count]);
    MPMediaItem *randomSong = [resultingMediaItemFromQuery objectAtIndex:randomNumberInSongCount];
    MPMediaItemCollection *currentPlaylistCollection = [MPMediaItemCollection collectionWithItems:@[randomSong]];
    block(currentPlaylistCollection);
}

-(void)checkIfSongIsInLocalLibrary:(MPMediaEntityPersistentID)persistentID withCompletionBlock:(void (^) (BOOL)) completionBlock {
    
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    NSArray *allSongs = [everything items];

    for (MPMediaItem *song in allSongs) {
        if (song.persistentID == persistentID) {
            completionBlock(YES);
            return;
        }
    }
    completionBlock(NO);
}

@end
