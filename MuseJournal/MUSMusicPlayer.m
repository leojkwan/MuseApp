//
//  MUSMusicPlayer.m
//  MuseApp

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


-(void)loadMPCollectionFromFormattedMusicPlaylist:(NSArray *)playlist completionBlock:(void (^)(MPMediaItemCollection *))block {
    
    self.playlistCollection = [[NSMutableArray alloc] init];
    
    if (playlist.count > 0) {
        
        for (Song *song in playlist) {
            
            MPMediaPropertyPredicate *songArtistPredicate =
            [MPMediaPropertyPredicate predicateWithValue:song.artistName
                                             forProperty:MPMediaItemPropertyArtist];
            
            MPMediaPropertyPredicate *trackNamePredicate =
            [MPMediaPropertyPredicate predicateWithValue:song.songName
                                             forProperty:MPMediaItemPropertyTitle];
            
            MPMediaQuery *songAndArtistQuery = [ [MPMediaQuery alloc] init];
            [songAndArtistQuery addFilterPredicate:songArtistPredicate];
            [songAndArtistQuery addFilterPredicate:trackNamePredicate];
            
            // Store the queried MPMediaItems in an NSArray
            NSArray *resultingMediaItemFromQuery  = [songAndArtistQuery items];
            // add MPMediaItems into MPMediaCollection
            if (resultingMediaItemFromQuery.count > 1) { // there is a duplicate, just take the first one
                [self.playlistCollection addObject:resultingMediaItemFromQuery[0]];
            }
            else if (resultingMediaItemFromQuery.count == 1) {
                [self.playlistCollection addObjectsFromArray:resultingMediaItemFromQuery];
            } else{
                [self.playlistCollection addObject:[NSNull null]];
            }
               }
        // at this point I have an array full of the media items that I want, which is playlist collection
        
        MPMediaItemCollection *currentPlaylistCollection = [MPMediaItemCollection collectionWithItems:self.playlistCollection];
        
        block(currentPlaylistCollection);
    }
    return;
}



-(void)returnRandomSongInLibraryWithCompletionBlock:(void (^)(MPMediaItemCollection *))block {
    MPMediaQuery *allSongsQuery = [ [MPMediaQuery alloc] init];
    NSArray *resultingMediaItemFromQuery = [allSongsQuery items];
    NSUInteger randomNumberInSongCount = arc4random_uniform((uint32_t) [resultingMediaItemFromQuery count]);
    if (randomNumberInSongCount != 0) {
        MPMediaItem *randomSong = [resultingMediaItemFromQuery objectAtIndex:randomNumberInSongCount];
        MPMediaItemCollection *currentPlaylistCollection = [MPMediaItemCollection collectionWithItems:@[randomSong]];
        block(currentPlaylistCollection);
    }
}

-(void)checkIfSongIsInLocalLibrary:(Song *)song withCompletionBlock:(void (^) (BOOL)) completionBlock {
    
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    NSArray *allSongs = [everything items];
    
    for (MPMediaItem *localSong in allSongs) {
        if ([song.artistName isEqualToString:localSong.artist] && [song.songName isEqualToString:localSong.title]) {
            completionBlock(YES);
            return;
        }
    }
    completionBlock(NO);
}

@end
