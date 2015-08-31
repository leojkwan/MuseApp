//
//  MUSPlaylistViewController.m
//
//
//  Created by Leo Kwan on 8/24/15.
//
//

#import "MUSPlaylistViewController.h"
#import "Song.h"
#import "MUSDataStore.h"
#import "MUSSongTableViewCell.h"
#import <Masonry.h>
#import <NAKPlaybackIndicatorView/NAKPlaybackIndicatorView.h>
#import "MUSIconAnimation.h"

@interface MUSPlaylistViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *playlistTableView;
@property (weak, nonatomic) IBOutlet UIImageView *currentSongView;
@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;
@property (nonatomic, strong) MUSDataStore *store;
@property (weak, nonatomic) IBOutlet UILabel *currentSongLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentArtistLabel;
@property (nonatomic, strong) NSString *currentPlayingSongString;
@property (weak, nonatomic) IBOutlet UIButton *playbackButtonStatus;
@property (nonatomic, strong) NSNotificationCenter *currentMusicPlayingNotifications;

@end

@implementation MUSPlaylistViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.store = [MUSDataStore sharedDataStore];
    [self.musicPlayer.myPlayer beginGeneratingPlaybackNotifications];
    [self listenForSongChanges];
    [self listenForPlaybackState];
    [self updateButtonStatus];
    [self loadUILabels];
    self.playlistTableView.delegate = self;
    self.playlistTableView.dataSource = self;
    self.currentSongView.image = [[self.musicPlayer.myPlayer nowPlayingItem].artwork imageWithSize:CGSizeMake(500, 500)];;
   
}




#pragma mark - music player actions
- (IBAction)nextButtonPressed:(id)sender {
    NSLog(@"This is the index of the currently playing song! %ld", [self.musicPlayer.myPlayer indexOfNowPlayingItem]);
    [self.musicPlayer.myPlayer skipToNextItem];
    [self.playlistTableView reloadData];

}
- (IBAction)backButtonPressed:(id)sender {
    [self.musicPlayer.myPlayer skipToPreviousItem];
    [self.playlistTableView reloadData];
}
- (IBAction)playbackButtonPressed:(id)sender {
    // change music player playback state
    
    if (self.musicPlayer.myPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [self.musicPlayer.myPlayer pause];
    } else {
        [self.musicPlayer.myPlayer play];
    }
    
    // if external music is playing...
    // get all songs in one array so I can check whether the now playing song is part of the list, if not, load a fresh playlist
    NSMutableArray *songTitleArray = [[NSMutableArray alloc] init];

    for (NSArray *song in self.playlistForThisEntry) {
        NSString *songName = song[1];
        [songTitleArray addObject:songName];
    }
    
    NSLog(@"%@", self.playlistForThisEntry);
        if (![songTitleArray containsObject:self.currentPlayingSongString]) {
            [self loadPlaylistArrayForThisEntryIntoPlayer];
        }

    [self updateButtonStatus];
    [self.playlistTableView reloadData];
}



- (IBAction)exitButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}

#pragma mark - music notifications and handling

- (void)updateButtonStatus {
    if (self.musicPlayer.myPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [self.playbackButtonStatus setImage:[UIImage imageNamed:@"pauseSong"] forState:UIControlStateNormal];
    } else {
        [self.playbackButtonStatus setImage:[UIImage imageNamed:@"playSong"] forState:UIControlStateNormal];
    }
}

-(void)updatePlaybackButton:(id)sender {
    NSLog(@"SONG STOPPED OR STARTED!");
    [self updateButtonStatus];
    [self.playlistTableView reloadData];
}

-(void)listenForPlaybackState {
    [self.currentMusicPlayingNotifications addObserver: self
                                selector: @selector (updatePlaybackButton:)
                                    name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                  object: self.musicPlayer.myPlayer];
}


-(void)listenForSongChanges {
    self.currentMusicPlayingNotifications = [NSNotificationCenter defaultCenter];
    [self.currentMusicPlayingNotifications addObserver: self
                                         selector: @selector(updateNowPlayingItem:)
                                             name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                           object: self.musicPlayer.myPlayer];
    
}

- (void)updateNowPlayingItem:(id) sender {
    [self performSelector:@selector(loadUILabels) withObject:self afterDelay:0.0];
}

-(void)loadUILabels {
    self.currentSongLabel.text = [self.musicPlayer.myPlayer nowPlayingItem].title;
    self.currentArtistLabel.text = [self.musicPlayer.myPlayer nowPlayingItem].artist;
    self.currentSongView.image = [[self.musicPlayer.myPlayer nowPlayingItem].artwork imageWithSize:CGSizeMake(500, 500)];
    [self.playlistTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return self.playlistForThisEntry.count;
}

//FIXME some problem

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MUSSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songReuseCell" forIndexPath:indexPath];
    
    // Set Up artist and song title labels
    NSString *artistStringAtThisRow = self.playlistForThisEntry[indexPath.row][0];
    NSString *songStringAtThisRow = self.playlistForThisEntry[indexPath.row][1];
    NSNumber *songNumber = @(indexPath.row + 1);
    cell.songTitleLabel.text = [NSString stringWithFormat:@"%@.  %@", songNumber, songStringAtThisRow];
    cell.artistLabel.text = [NSString stringWithFormat:@"%@." , artistStringAtThisRow];
    
    // set up image
    if (self.artworkImagesForThisEntry[indexPath.row]) {
        cell.songArtworkImageView.image = self.artworkImagesForThisEntry[indexPath.row];
    } else {
        cell.songArtworkImageView.image = nil;
    }
    
    //set up animating icon
    self.currentPlayingSongString = [self.musicPlayer.myPlayer nowPlayingItem].title;
    NSLog(@"%@", self.currentPlayingSongString);
    if ([songStringAtThisRow isEqualToString:self.currentPlayingSongString ] && self.musicPlayer.myPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        NSLog(@"Do you ever get in this playing song conditional?");
        [cell.animatingIcon startAnimating];
        [cell.animatingIcon setHidden:NO];
    }
//    else if ([songStringAtThisRow isEqualToString:self.currentPlayingSongString ] && self.musicPlayer.myPlayer.playbackState == MPMusicPlaybackStatePaused){
//        NSLog(@"Do you ever get in this paused song conditional?");
//        [cell.animatingIcon stopAnimating];
//        [cell.animatingIcon setHidden:NO];
//    }
    
    else {
        NSLog(@"Do you ever get in this else song conditional?");
        // hide all icons of not playing cell
        [cell.animatingIcon setHidden:YES];
    }
        return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // first I have to delete from array
        [self.playlistForThisEntry removeObjectAtIndex:indexPath.row];
        
        // Update artwork array
        [self.artworkImagesForThisEntry removeObjectAtIndex:indexPath.row];
        
        
        // then delete from core data model
        NSArray *songsForThisEntry = [[self.destinationEntry.songs allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinnedAt" ascending:YES]]];
        Song *songToDelete = [songsForThisEntry objectAtIndex:indexPath.row];
        [self.destinationEntry removeSongsObject:songToDelete];
        
        
        // Save to Core Data
        [self.store save];
        
        
        [self.playlistTableView reloadData];
    }
}

-(void)loadPlaylistArrayForThisEntryIntoPlayer {
    if (self.destinationEntry != nil) {
        [self.musicPlayer loadMPCollectionFromFormattedMusicPlaylist:self.playlistForThisEntry withCompletionBlock:^(MPMediaItemCollection *response) {
            MPMediaItemCollection *playlistCollectionForThisEntry = response;
            // WHEN WE FINISH THE SORTING AND FILTERING, ADD MUSIC TO QUEUE AND PLAY THAT DAMN THING!!!
            [self.musicPlayer.myPlayer setQueueWithItemCollection:playlistCollectionForThisEntry];
            [self.musicPlayer.myPlayer play];
        }];
    }
}


@end
