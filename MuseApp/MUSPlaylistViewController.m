//
//  MUSPlaylistViewController.m
//  
//
//  Created by Leo Kwan on 8/24/15.
//
//

#import "MUSPlaylistViewController.h"
#import "MUSSongTableViewCell.h"

@interface MUSPlaylistViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *playlistTableView;
@property (weak, nonatomic) IBOutlet UIImageView *currentSongView;

@end

@implementation MUSPlaylistViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.playlistTableView.delegate = self;
    self.playlistTableView.dataSource = self;
    
    
    UIImageView *whiteMask = [[UIImageView alloc]initWithImage:[UIImage imageNamed: @"whiteMask" ]];
    [whiteMask setContentMode:UIViewContentModeScaleAspectFit];
    [self.playlistTableView addSubview:whiteMask];
    
    
}

- (IBAction)exitButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
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
    cell.songTitleLabel.text = [NSString stringWithFormat:@"%@.  %@ by %@", songNumber, songStringAtThisRow, artistStringAtThisRow];
    cell.songArtworkImageView.image = self.artworkImagesForThisEntry[indexPath.row];
    return cell;
}



@end
