//
//  MUSDetailEntryViewController.m
//  MuseApp
//
//  Created by Leo Kwan on 8/23/15.
//  Copyright (c) 2015 Leo Kwan. All rights reserved.
//

#import "MUSDetailEntryViewController.h"
#import "MUSDataStore.h"
#import "Entry.h"
#import "Song.h"

@interface MUSDetailEntryViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *secondary;

@end

@implementation MUSDetailEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)saveButtonTapped:(id)sender {
    NSLog(@"ARE YOU GETTING CALLED?");
    MUSDataStore *store = [MUSDataStore sharedDataStore];
    
    Entry *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"MUSEntry" inManagedObjectContext:store.managedObjectContext];
    newEntry.titleOfEntry = self.textField.text;

    
    Song *song =  [NSEntityDescription insertNewObjectForEntityForName:@"MUSSong" inManagedObjectContext:store.managedObjectContext];
    song.songName = self.secondary.text;

    [newEntry addSongsObject:song];
    

    
    
    [store save];
    [self.navigationController popViewControllerAnimated:YES];
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
