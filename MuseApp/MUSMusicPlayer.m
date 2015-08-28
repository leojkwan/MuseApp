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
        // set currently playing song on instantiation
        self.currentlyPlayingSong = [self.myPlayer nowPlayingItem];
//        [self enableSongListeningNotifications];
    }
    return self;
}

//
-(void)loadPlaylistArtworkForThisEntryWithCompletionBlock:(void (^)(NSMutableArray *))block {
    
    NSMutableArray *arrayOfSongImages = [[NSMutableArray alloc] init];
    for (MPMediaItem *song in self.playlistCollection) {
        UIImage *artworkForThisSong = [song.artwork imageWithSize:CGSizeMake(200, 200)];
        [arrayOfSongImages addObject:artworkForThisSong];
    }
    block(arrayOfSongImages);
}


-(void *)loadMPCollectionFromFormattedMusicPlaylist:(NSMutableArray *)playlist withCompletionBlock:(void (^)(MPMediaItemCollection *))block {

self.playlistCollection = [[NSMutableArray alloc] init];

if (playlist.count > 0) {
    
    for (NSArray *song in playlist) {
        
        MPMediaPropertyPredicate *artistPredicate =
        [MPMediaPropertyPredicate predicateWithValue:song[0]
                                         forProperty:MPMediaItemPropertyArtist];
        
        
        MPMediaPropertyPredicate *songPredicate =
        [MPMediaPropertyPredicate predicateWithValue:song[1]
                                         forProperty:MPMediaItemPropertyTitle];
        
        
        MPMediaQuery *songAndArtistQuery = [ [MPMediaQuery alloc] init];
        [songAndArtistQuery addFilterPredicate:artistPredicate];
        [songAndArtistQuery addFilterPredicate:songPredicate];
        
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

-(void)checkIfSongIsInLocalLibrary:(NSString *)songString withCompletionBlock:(void (^) (BOOL)) completionBlock {
    
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    NSArray *allSongs = [everything items];
    

    for (MPMediaItem *song in allSongs) {
        if ([song.title isEqualToString:songString]) {
            completionBlock(YES);
        }
    }
    completionBlock(NO);
}

-(void) enableSongListeningNotifications {
    
    self.currentMusicPlayingNotifications = [NSNotificationCenter defaultCenter];
    [self.currentMusicPlayingNotifications addObserver: self
                                selector: @selector(nowPlayingItemChanged:)
                                    name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                  object: self.myPlayer];
    
    [self.myPlayer beginGeneratingPlaybackNotifications];
}


- (void)nowPlayingItemChanged:(id) sender {
    self.currentlyPlayingSong = [self.myPlayer nowPlayingItem];
}


-(void)removeMusicNotifications {

    
        [self.currentMusicPlayingNotifications removeObserver:self
                                           name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                         object:self.myPlayer];
    
        [self.currentMusicPlayingNotifications removeObserver:self
                                           name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                         object:self.myPlayer];
    
        [self.myPlayer endGeneratingPlaybackNotifications];
}


// this class needs to play the song from a entry queue
// it needs to listen for currently playing song



@end
