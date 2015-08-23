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
#import <Masonry/Masonry.h>
#import "Song.h"
#import <UIScrollView+APParallaxHeader.h>


@interface MUSDetailEntryViewController ()<APParallaxViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *secondary;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation MUSDetailEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2000);
        make.width.equalTo(self.scrollView.mas_width);
//        make.left.and.right.and.top.equalTo(self.scrollView);
        self.contentView.backgroundColor = [UIColor orangeColor];
        
        [self.scrollView addParallaxWithImage:[UIImage imageNamed:@"drink"] andHeight:300 andShadow:NO];

        
    }];
    
    
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
