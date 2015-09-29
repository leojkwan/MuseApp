//
//  TestViewController.m
//  MuseJournal
//
//  Created by Leo Kwan on 9/28/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

#import "TestViewController.h"
#import "UIImagePickerController+ExtraMethods.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttontapped:(id)sender {

    [UIImagePickerController obtainPermissionForMediaSourceType:UIImagePickerControllerSourceTypePhotoLibrary withSuccessHandler:^{
        //            [self presentViewController:imagePicker animated:YES completion:nil];
        NSLog(@"success!");
    } andFailure:^{
        UIAlertController *alertController= [UIAlertController
                                             alertControllerWithTitle:nil
                                             message:NSLocalizedString(@"You have disabled Photos access", nil)
                                             preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Open Settings", @"Photos access denied: open the settings app to change privacy settings")
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action) {
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                    }]
         ];
        [alertController addAction:[UIAlertAction
                                    actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                    style:UIAlertActionStyleDefault
                                    handler:NULL]
         ];
        alertController.popoverPresentationController.sourceView = sender;
        alertController.popoverPresentationController.sourceRect = [sender bounds];
        [self presentViewController:alertController animated:YES completion:nil];
    }];

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
