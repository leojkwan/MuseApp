//
//  MUSSettingsTableViewController.m
//  
//
//  Created by Leo Kwan on 9/29/15.
//
//

#import "MUSSettingsTableViewController.h"
#import "UIFont+MUSFonts.h"


@interface MUSSettingsTableViewController ()

@end

@implementation MUSSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self prefersStatusBarHidden];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    [self styleNavBarCustomLabelAttributes];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 75, 0);


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)styleNavBarCustomLabelAttributes {
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.98 green:0.95 blue:0.44 alpha:1]];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.98 green:0.95 blue:0.44 alpha:1];

    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:0.98 green:0.95 blue:0.44 alpha:1]];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys: [UIColor blackColor],NSForegroundColorAttributeName,
      [UIFont fontWithName:@"AvenirNext-Medium" size:18],
      NSFontAttributeName, nil]];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setHidden:NO];
    // Change System Font UI Label
  
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.98 green:0.92 blue:0.55 alpha:1];
    [cell setSelectedBackgroundView:bgColorView];
    
//
//    if (indexPath.row == 0) {
//
//    } else if (indexPath.row == 6) {
//        if ([[iTellAFriend sharedInstance] canTellAFriend]) {
////            UINavigationController* tellAFriendController = [[iTellAFriend sharedInstance] tellAFriendController];
////            [self presentViewController:tellAFriendController animated:YES completion:nil];
//
//        }
//    } else if (indexPath.row == 7) {
////        [[iTellAFriend sharedInstance] rateThisAppWithAlertView:YES];
//        }
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
