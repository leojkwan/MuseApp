//
//  MUSAboutTableViewController.m
//  Muse
//
//  Created by Leo Kwan on 10/18/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "MUSAboutTableViewController.h"
#import "iTellAFriend.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MUSAboutTableViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation MUSAboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 300;
    }
    return 50;
}


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


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
