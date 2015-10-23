//
//  MUSMarkdownViewController.m
//  Muse
//
//  Created by Leo Kwan on 10/23/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSMarkdownViewController.h"
#import "MUSMarkdownTableViewCell.h"

@interface MUSMarkdownViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *markdownTableView;
@property(strong, nonatomic) NSArray *markdownArray;


@end

@implementation MUSMarkdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.markdownTableView.delegate = self;
        self.markdownTableView.dataSource = self;
    // remove empty cell hairline
    self.markdownTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    self.markdownArray = @[
                           @[@"",@""],
                           @[@"",@""],
                           @[@"",@""],
                           @[@"",@""],
                           @[@"",@""],
                           @[@"",@""],
                           @[@"",@""],
                           @[@"",@""],
                           @[@"",@""]];
    
    UITapGestureRecognizer *exitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitModal)];
    [self.view addGestureRecognizer:exitTap];
    
}

-(void)exitModal {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 200;
    }
    return 75;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.markdownArray.count + 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header" forIndexPath:indexPath];
        return cell;
    }
    
    MUSMarkdownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"syntaxCell" forIndexPath:indexPath];
    cell.syntaxTitle = self.markdownArray[indexPath.row -1 ][0];
    cell.syntaxExample = self.markdownArray[indexPath.row -1 ][1];
    
    return cell;
}


@end
