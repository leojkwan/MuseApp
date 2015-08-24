//
//  MUSPlaylistViewController.m
//  
//
//  Created by Leo Kwan on 8/24/15.
//
//

#import "MUSPlaylistViewController.h"

@interface MUSPlaylistViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *playlistTableView;

@end

@implementation MUSPlaylistViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Hello!");
    
}

- (IBAction)exitButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"leaving~~~");
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return self.playlistForThisEntry.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songReuseCell" forIndexPath:indexPath];
    NSString *artistStringAtThisRow = self.playlistForThisEntry[indexPath.row][0];
    NSString *songStringAtThisRow = self.playlistForThisEntry[indexPath.row][1];
    NSNumber *songNumber = @(indexPath.row + 1);
    NSLog(@"%@", songStringAtThisRow);
    cell.textLabel.text = [NSString stringWithFormat:@"%@.  %@ by %@", songNumber, songStringAtThisRow, artistStringAtThisRow];

    return cell;
}



@end
