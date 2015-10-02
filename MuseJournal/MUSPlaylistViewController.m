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
#import "MUSIconAnimation.h"
#import "UIImage+ExtraMethods.h"
#import "UIFont+MUSFonts.h"

@interface MUSPlaylistViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *playlistTableView;
@property (weak, nonatomic) IBOutlet UIImageView *currentSongView;
@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;
@property (nonatomic, strong) MUSDataStore *store;
@property (weak, nonatomic) IBOutlet UILabel *currentSongLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentArtistLabel;
@property (weak, nonatomic) IBOutlet UIButton *playbackButtonStatus;
@property (nonatomic, strong) NSNotificationCenter *currentMusicPlayingNotifications;
@property (nonatomic, strong) NSMutableArray *artworkImagesForThisEntry;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView2;
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet UIImageView *playlistGaussian;



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
    
    
    self.playerView.layer.cornerRadius = 5;

    
    [self.musicPlayer loadPlaylistArtworkForThisEntryWithCompletionBlock:^(NSMutableArray *artworkImages) {
        self.artworkImagesForThisEntry = artworkImages;
    }];
    
    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitButtonPressed:)];
    [self.playlistGaussian addGestureRecognizer:dismissTap];
 }



#pragma mark - music player actions
- (IBAction)nextButtonPressed:(id)sender {
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
    if (![self currentlyPlayingSongIsInPlaylist]) {
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
    [self prefersStatusBarHidden];
}

-(BOOL)currentlyPlayingSongIsInPlaylist {
    NSMutableArray *songTitleArray = [[NSMutableArray alloc] init];
    
    for (Song *song in self.playlistForThisEntry) {
        NSNumber *songID = song.persistentID;
        [songTitleArray addObject:songID];
    }
    
    NSNumber *songPersistentNumber = [NSNumber numberWithUnsignedLongLong:[self.musicPlayer.myPlayer nowPlayingItem].persistentID];
    
    if (![songTitleArray containsObject:songPersistentNumber]) {
        return NO;
    }
    return YES;
}

#pragma mark - music notifications and handling

- (void)updateButtonStatus {
    
    if (self.playlistForThisEntry.count == 0) {
        [self.playbackButtonStatus setEnabled:NO];
    } else{
        [self.playbackButtonStatus setEnabled:YES];

    if (self.musicPlayer.myPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [self.playbackButtonStatus setImage:[UIImage imageNamed:@"pauseSong"] forState:UIControlStateNormal];
    } else {
        [self.playbackButtonStatus setImage:[UIImage imageNamed:@"playSong"] forState:UIControlStateNormal];
    }
    }
}

-(void)updatePlaybackButton:(id)sender {
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MUSSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songReuseCell" forIndexPath:indexPath];
    
    // Set Up artist and song title labels
    Song *songForThisRow = self.playlistForThisEntry[indexPath.row];
    NSString *artistStringAtThisRow = songForThisRow.artistName;
    NSString *songStringAtThisRow = songForThisRow.songName;
    
    cell.songTitleLabel.text = [NSString stringWithFormat:@"%@", songStringAtThisRow];
    cell.artistLabel.text = [NSString stringWithFormat:@"%@." , artistStringAtThisRow];
    cell.songNumberLabel.text = [NSString stringWithFormat: @"%ld.", (long)indexPath.row + 1];
    
    // set up image
    if (self.artworkImagesForThisEntry[indexPath.row]) {
        cell.songArtworkImageView.image = self.artworkImagesForThisEntry[indexPath.row];
    } else {
        cell.songArtworkImageView.image = nil;
    }
    
    NSUInteger indexPathForAnimation = [self.musicPlayer.myPlayer indexOfNowPlayingItem];
    if (indexPath.row == indexPathForAnimation && [self.currentSongLabel.text isEqualToString:cell.songTitleLabel.text]) {
        [cell.animatingIcon startAnimating];
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
        
        // reload collection queue with updated playlist
        [self loadPlaylistArrayForThisEntryIntoPlayer];
        
        // Save to Core Data
        [self.store save];
        [self.playlistTableView reloadData];
        [self updateButtonStatus];
    }
}

-(void)loadPlaylistArrayForThisEntryIntoPlayer {
    if (self.destinationEntry != nil) {
            MPMediaItemCollection *playlistCollectionForThisEntry =    [self.musicPlayer loadMPCollectionFromFormattedMusicPlaylist:self.playlistForThisEntry];
            // WHEN WE FINISH THE SORTING AND FILTERING, ADD MUSIC TO QUEUE AND PLAY THAT DAMN THING!!!
            [self.musicPlayer.myPlayer setQueueWithItemCollection:playlistCollectionForThisEntry];
            [self.musicPlayer.myPlayer play];
    }
}


@end
