//  LastViewController.m
//  Pods



//  Created by Leo Kwan on 10/7/15.


#import "LastViewController.h"

@interface LastViewController ()
@end


@implementation LastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)doneButtonPressed:(id)sender {
    
        UIStoryboard *tourist = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController *destination = [tourist instantiateInitialViewController];
        
        UIViewController *presentingViewController = self.presentingViewController;
        
        [presentingViewController dismissViewControllerAnimated:NO completion:^{
            [presentingViewController presentViewController:destination animated:NO completion:nil];
        }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    [self dismissViewControllerAnimated:YES completion:^{
        
        
        
    }];
    
}


@end
