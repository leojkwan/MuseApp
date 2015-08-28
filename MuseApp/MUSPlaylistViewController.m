//
//  MUSPlaylistViewController.m
//  
//
//  Created by Leo Kwan on 8/24/15.
//
//

#import "MUSPlaylistViewController.h"
#import "MUSSongTableViewCell.h"
#import <Masonry.h>

@interface MUSPlaylistViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *playlistTableView;
@property (weak, nonatomic) IBOutlet UIImageView *currentSongView;
@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;

@end

@implementation MUSPlaylistViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.playlistTableView.delegate = self;
    self.playlistTableView.dataSource = self;
    

    self.currentSongView.image = self.artworkForNowPlayingSong;

}

- (IBAction)exitButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return self.playlistForThisEntry.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MUSSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songReuseCell" forIndexPath:indexPath];
    NSString *artistStringAtThisRow = self.playlistForThisEntry[indexPath.row][0];
    NSString *songStringAtThisRow = self.playlistForThisEntry[indexPath.row][1];
    NSNumber *songNumber = @(indexPath.row + 1);
    NSLog(@"%@", songStringAtThisRow);
    cell.songTitleLabel.text = [NSString stringWithFormat:@"%@.  %@", songNumber, songStringAtThisRow];
    cell.artistLabel.text = [NSString stringWithFormat:@" by %@." , artistStringAtThisRow];
    cell.songArtworkImageView.image = self.artworkImagesForThisEntry[indexPath.row];
    return cell;
}



@end
