//
//  MUSSettingsTableViewController.m
//  
//
//  Created by Leo Kwan on 9/29/15.
//
//

#import "MUSSettingsTableViewController.h"
#import "UIFont+MUSFonts.h"
#import "iTellAFriend.h"


@interface MUSSettingsTableViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@end

@implementation MUSSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    
    self.userNameTextField.delegate = self;
    
    // remove empty cell hairline
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    [self styleNavBarCustomLabelAttributes];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 75, 0);
    
    [self setUpNameTextField];
}


-(void)saveUserName {
    NSString *updatedFirstName = self.userNameTextField.text;
    [[NSUserDefaults standardUserDefaults] setObject:updatedFirstName forKey:@"userFirstName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.userNameTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userNameTextField) {
        [self saveUserName];
        return NO;
    }
    return YES;
}


-(void)setUpNameTextField {
    NSString *currentFirstName =  [[NSUserDefaults standardUserDefaults] objectForKey:@"userFirstName"];
    self.userNameTextField.text = currentFirstName;
}


-(void)styleNavBarCustomLabelAttributes {
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];

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
    
    if ([self.userNameTextField isFirstResponder]) {
        [self saveUserName];
    }
    [self performSegueWithIdentifier:@"backToHomeView" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.98 green:0.92 blue:0.55 alpha:1];
    [cell setSelectedBackgroundView:bgColorView];
    

  
    
    if (indexPath.row == 3) {
        if ([[iTellAFriend sharedInstance] canTellAFriend]) {
            UINavigationController* tellAFriendController = [[iTellAFriend sharedInstance] tellAFriendController];
            [self presentViewController:tellAFriendController animated:YES completion:nil];

        }
    } else if (indexPath.row == 4) {
        [[iTellAFriend sharedInstance] rateThisAppWithAlertView:YES];
        }
    
    
    // DESELECT CELL COLOR
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
