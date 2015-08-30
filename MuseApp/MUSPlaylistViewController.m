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

@end

@implementation MUSPlaylistViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.store = [MUSDataStore sharedDataStore];
    [self listenForSongChanges];
    [self updateNowPlayingItem:nil];
    self.playlistTableView.delegate = self;
    self.playlistTableView.dataSource = self;
//    self.currentSongView.image = self.artworkForNowPlayingSong;
    
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

-(void)listenForSongChanges {
    NSNotificationCenter *currentMusicPlayingNotifications = [NSNotificationCenter defaultCenter];
    [currentMusicPlayingNotifications addObserver: self
                                         selector: @selector(updateNowPlayingItem:)
                                             name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                           object: self.musicPlayer.myPlayer];
    
    [self.musicPlayer.myPlayer beginGeneratingPlaybackNotifications];
}

- (void)updateNowPlayingItem:(id) sender {
    UIImage *currentSongImage = [self.musicPlayer.currentlyPlayingSong.artwork imageWithSize:CGSizeMake(self.view.frame.size.width, 300)];
    self.currentSongView.image = currentSongImage;
    self.currentSongLabel.text = self.musicPlayer.currentlyPlayingSong.title;
    self.currentArtistLabel.text = self.musicPlayer.currentlyPlayingSong.artist;
//    self.currentlyPlayingSong = [self.myPlayer nowPlayingItem];
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
    cell.songArtworkImageView.image = self.artworkImagesForThisEntry[indexPath.row];
    
    //set up animating icon
    [cell.animatingIcon startAnimating];
    
    
    
    
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




@end
