//
//  MUSSettingsTableViewController.m
//  
//
//  Created by Leo Kwan on 9/29/15.
//
//

#import "MUSSettingsTableViewController.h"
#import "iTellAFriend.h"

@interface MUSSettingsTableViewController ()

@end

@implementation MUSSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self prefersStatusBarHidden];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 0;
    }
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {

    } else if (indexPath.row == 6) {
        if ([[iTellAFriend sharedInstance] canTellAFriend]) {
            UINavigationController* tellAFriendController = [[iTellAFriend sharedInstance] tellAFriendController];
            [self presentViewController:tellAFriendController animated:YES completion:nil];

        }
    } else if (indexPath.row == 7) {
        [[iTellAFriend sharedInstance] rateThisAppWithAlertView:YES];
        }
}

-(BOOL)prefersStatusBarHidden {
    return NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
