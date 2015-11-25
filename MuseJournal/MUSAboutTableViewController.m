//
//  MUSAboutTableViewController.m
//  Muse
//
//  Created by Leo Kwan on 10/18/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSAboutTableViewController.h"
#import "iTellAFriend.h"
#import "UIColor+MUSColors.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MUSAboutTableViewController ()<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *MUSCellContentView;

@end

@implementation MUSAboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   
    // set color of first table view cell
    self.MUSCellContentView.backgroundColor = [UIColor MUSSolitude];
    
    // set bottom padding
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 200, 0)];

}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIView *bgColorView = [[UIView alloc] init];

    bgColorView.backgroundColor = [UIColor colorWithRed:0.98 green:0.92 blue:0.55 alpha:1];
    [cell setSelectedBackgroundView:bgColorView];
    
    
    if (indexPath.row == 1)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.leojkwan.com"]];
    
    else if (indexPath.row == 3) {
        
        
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
            mailCont.mailComposeDelegate = self;
            
            [mailCont setSubject:@"Muse App Feedback!"];
            [mailCont setToRecipients:[NSArray arrayWithObject:@"leojkwan@gmail.com"]];
            [mailCont setMessageBody:@"" isHTML:NO];
            
            [self presentViewController:mailCont animated:YES completion:nil];
        }
        
    }
    
    // DESELECT CELL COLOR
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
